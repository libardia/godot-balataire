class_name Pile
extends Node2D

# ==================================================================================================

## How many cards are visible on top of the pile.
## A value of 0 or less will always spread out all cards.
@export var spread: int = 1
## Offset applied to each card when spreading.
@export var spread_offset: Vector2 = Vector2.ZERO
## When set, only the top card is clickable, even if more face-up cards are spread.
## Used for the stock.
@export var only_top_card_clickable: bool = false
## Exposed for testing during game
@export var respread: bool = true

@onready var click_area: Area2D = $PileClickArea

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


func place_card(card: Card, face_up: bool):
    card.reparent(self)
    card.target_face_up = face_up
    card.pile = self
    card.pile_index = len(cards)
    cards.push_back(card)
    respread = true


func move_cards_from(new_pile: Pile, index: int, face_up: bool):
    var eff_index = mini(index, 0)
    var to_move = cards.slice(eff_index)
    cards = cards.slice(0, eff_index)
    for card in to_move:
        new_pile.place_card(card, face_up)
    respread = true


func move_n_cards(new_pile: Pile, num_cards: int, face_up: bool):
    move_cards_from(new_pile, len(cards) - num_cards, face_up)


func do_spread():
    # eff_spread will always be at least 1 if the list is not empty,
    # so this should never give an out-of-bounds error
    var eff_spread = len(cards) if spread <= 0 else spread
    var thresh = max(0, len(cards) - eff_spread)
    for i in len(cards):
        var card = cards[i]
        card.click_area.input_pickable = i >= thresh and card.target_face_up and not only_top_card_clickable
        CardTweener.tween(card, spread_offset * max(0, i - thresh))
        #card.position = spread_offset * max(0, i - thresh)
    if only_top_card_clickable and not cards.is_empty():
        cards.back().click_area.input_pickable = true
    respread = false


func _on_card_input(_viewport: Node, event: InputEvent, _shape_idx: int, card: Card) -> void:
    print(str("card ", card, " clicked in pile"))
    if event.is_action_released("select"):
        clicked_cards.push_back(card)


func _on_pile_input(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
    if event.is_action_released("select"):
        selected.emit()
