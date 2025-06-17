extends Node

# ==================================================================================================

@onready var deck: Deck = $Layout/TopRow/Deck
@onready var stock: Pile = $Layout/TopRow/Stock

# ==================================================================================================

func _on_deck_selected() -> void:
    deck.draw_n(stock, 3, true)


func _on_stock_card_selected() -> void:
    pass
