extends Node

# ==================================================================================================

@export var stock_deal_delay: float
@export var initial_deal_delay: float
@export var holding_offset: Vector2

@onready var deck: Deck = $Layout/TopRow/Deck
@onready var stock: Pile = $Layout/TopRow/Stock
@onready var holding: Pile = $Holding

var piles: Array[Pile] = []
var homes: Array[Pile] = []
var accept_input: bool = false
var deal_thread: Thread

var moving: bool = false
var moving_from_pile: Pile = null

# ==================================================================================================

func _ready() -> void:
    for i in 7:
        var p := get_node("Layout/MainPiles/Pile%s" % i) as Pile
        piles.push_back(p)
        p.card_selected.connect(_on_pile_card_selected)
        p.selected.connect(_on_pile_selected)
    for i in 4:
        var h := get_node("Layout/TopRow/Home%s" % i) as Pile
        homes.push_back(h)
    deal_thread = Thread.new()
    deal_thread.start(deal)


func _process(_delta: float) -> void:
    holding.global_position = get_viewport().get_mouse_position() + holding_offset


func _on_deck_selected(_pile: Pile, pressed: bool) -> void:
    if accept_input and not pressed:
        accept_input = false
        if deck.cards.is_empty():
            # Reset cards
            for i in stock.cards.size():
                var c = stock.cards[-i - 1]
                deck.place_card(c, false)
            stock.cards = []
            TimerHelper.delay_fire(stock_deal_delay, do_draw)
        else:
            do_draw()


func _on_stock_card_selected(card: Card, pressed: bool) -> void:
    if accept_input:
        print("Clicked on card in stock: ", card.name)
        if not moving and pressed:
            begin_move(card)


func _on_pile_card_selected(card: Card, pressed: bool) -> void:
    if accept_input:
        print("Clicked on card in pile: ", card.name)
        if not moving and pressed:
            begin_move(card)
        elif moving and not pressed:
            finish_move(card.pile)


func _on_pile_selected(pile: Pile, pressed: bool) -> void:
    if accept_input:
        if moving and not pressed and pile.cards.is_empty():
            finish_move(pile)


func deal():
    for i in piles.size():
        for j in range(i, piles.size()):
            deck.draw_n.call_deferred(piles[j], 1, j == i)
            OS.delay_msec(round(initial_deal_delay * 1000))
    accept_input = true


func do_draw():
    var num_to_draw := mini(3, deck.cards.size())
    TimerHelper.delay_fire(num_to_draw * stock_deal_delay, func (): accept_input = true)
    # Make 3 (or less) timers to draw the cards
    for i in num_to_draw:
        TimerHelper.delay_fire(i * stock_deal_delay, deck.draw_n.bind(stock, 1))


func begin_move(card: Card):
    if not moving:
        moving = true
        moving_from_pile = card.pile
        card.pile.move_cards_from(holding, card.pile_index)


func cancel_move():
    if moving:
        holding.move_cards_from(moving_from_pile, 0)
        moving_from_pile = null
        moving = false

func finish_move(pile: Pile):
    if moving:
        holding.move_cards_from(pile, 0)
        moving_from_pile = null
        moving = false
