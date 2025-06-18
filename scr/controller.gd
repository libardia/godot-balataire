extends Node

# ==================================================================================================

@export var deal_delay: float

@onready var deck: Deck = $Layout/TopRow/Deck
@onready var stock: Pile = $Layout/TopRow/Stock

var can_draw: bool = true

# ==================================================================================================

func _on_deck_selected() -> void:
    if can_draw:
        can_draw = false
        if deck.cards.is_empty():
            # Reset cards
            for i in stock.cards.size():
                var c = stock.cards[-i - 1]
                deck.place_card(c, false)
            stock.cards = []
            TimerHelper.delay_fire(deal_delay, do_draw)
        else:
            do_draw()


func do_draw():
    var num_to_draw := mini(3, deck.cards.size())
    TimerHelper.delay_fire(num_to_draw * deal_delay, func (): can_draw = true)
    # Make 3 (or less) timers to draw the cards
    for i in num_to_draw:
        TimerHelper.delay_fire(i * deal_delay, deck.draw_n.bind(stock, 1, true))


func _on_stock_card_selected() -> void:
    pass
