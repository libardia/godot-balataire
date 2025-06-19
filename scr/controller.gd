extends Node

# ==================================================================================================

@export var stock_deal_delay: float

@onready var deck: Deck = $Layout/TopRow/Deck
@onready var stock: Pile = $Layout/TopRow/Stock

var piles: Array[Pile] = []
var homes: Array[Pile] = []
var can_draw: bool = true
var accept_input: bool = false
var deal_thread: Thread

# ==================================================================================================

func _ready() -> void:
    for i in 7:
        var p := get_node("Layout/MainPiles/Pile%s" % i) as Pile
        piles.push_back(p)
    for i in 4:
        var h := get_node("Layout/TopRow/Home%s" % i) as Pile
        homes.push_back(h)
    deal_thread = Thread.new()
    deal_thread.start(deal)


func _on_deck_selected() -> void:
    if can_draw and accept_input:
        can_draw = false
        if deck.cards.is_empty():
            # Reset cards
            for i in stock.cards.size():
                var c = stock.cards[-i - 1]
                deck.place_card(c, false)
            stock.cards = []
            TimerHelper.delay_fire(stock_deal_delay, do_draw)
        else:
            do_draw()


func _on_stock_card_selected() -> void:
    pass


func deal():
    for i in piles.size():
        print(piles[i])


func do_draw():
    var num_to_draw := mini(3, deck.cards.size())
    TimerHelper.delay_fire(num_to_draw * stock_deal_delay, func (): can_draw = true)
    # Make 3 (or less) timers to draw the cards
    for i in num_to_draw:
        TimerHelper.delay_fire(i * stock_deal_delay, deck.draw_n.bind(stock, 1, true))
