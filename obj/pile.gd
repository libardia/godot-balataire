class_name Pile
extends Node2D

# ==================================================================================================

## How many cards are visible on top of the pile.
## A value of 0 or less will always spread out all cards.
@export
var spread: int = 1
## Offset applied to each card when spreading.
@export
var spread_offset: Vector2 = Vector2.ZERO
## Exposed for testing during game
@export
var respread: bool = true

@onready
var click_area: Area2D = $PileClickArea

var cards: Array[Card] = []
var clicked_cards: Array[Card] = []

signal selected
signal card_selected(card: Card)

# ==================================================================================================

func _ready() -> void:
    pass


func _process(_delta: float) -> void:
    if respread:
        do_spread()
    if not clicked_cards.is_empty():
        var lowest: Card = clicked_cards[0]
        for card in clicked_cards:
            if lowest.pile_index > card.pile_index:
                lowest = card
        clicked_cards.clear()
        card_selected.emit(lowest)


func place_pile(pile: Pile):
    for card in pile.cards:
        place_card(card)


func place_card(card: Card):
    card.reparent(self, false)
    card.click_area.input_event.connect(_on_card_input.bind(card))
    card.pile_index = len(cards)
    cards.push_back(card)
    respread = true


func do_spread():
    # eff_spread will always be at least 1 if the list is not empty,
    # so this should never give an out-of-bounds error
    var eff_spread = len(cards) if spread <= 0 else spread
    var thresh = len(cards) - eff_spread
    for i in len(cards):
        var card = cards[i]
        card.click_area.input_pickable = i >= thresh
        card.position = spread_offset * max(0, i - thresh)
    respread = false


func _on_card_input(_viewport: Node, event: InputEvent, _shape_idx: int, card: Card) -> void:
    print(str("card ", card, " clicked in pile"))
    if event.is_action_released("select"):
        clicked_cards.push_back(card)


func _on_pile_input(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
    if event.is_action_released("select"):
        selected.emit()
