class_name Pile
extends Node2D

# ==================================================================================================

var logger := LogUtil.make_logger(self)

## How many cards are visible on top of the pile.
## A value of 0 or less will always spread out all cards.
@export var spread: int = 1
## Offset applied to each card when spreading face-up cards.
@export var face_up_spread_offset: Vector2 = Vector2.ZERO
## Offset applied to each card when spreading face-down cards.
@export var face_down_spread_offset: Vector2 = Vector2.ZERO
## When set, only the top card is clickable, even if more face-up cards are spread.
## Used for the stock.
@export var only_top_card_clickable: bool = false
# When set, no cards are clickable. Overrides "Only Top Card Clickable".
@export var none_clickable: bool = false
## Exposed for testing during game
@export var respread: bool = true

@onready var click_area: Area2D = $PileClickArea

var cards: Array[Card] = []
var clicked_cards: Array[Card] = []
var clicked_pressed: bool = false

signal selected(pile: Pile, pressed: bool)
signal card_selected(card: Card, pressed: bool)

# ==================================================================================================

func _ready() -> void:
    pass


func _process(_delta: float) -> void:
    if respread:
        do_spread()
    if not clicked_cards.is_empty():
        #print("Clicked cards: ", clicked_cards)
        var highest: Card = clicked_cards[0]
        for card in clicked_cards:
            if highest.pile_index < card.pile_index:
                highest = card
        clicked_cards.clear()
        #print("Emitting card: ", highest)
        card_selected.emit(highest, clicked_pressed)


func place_card(card: Card, face_up: bool):
    card.reparent(self)
    card.target_face_up = face_up
    card.pile = self
    card.pile_index = len(cards)
    cards.push_back(card)
    for con in card.click_area.input_event.get_connections():
        card.click_area.input_event.disconnect(con["callable"])
    card.click_area.input_event.connect(_on_card_input.bind(card))
    respread = true


func move_cards_from(new_pile: Pile, index: int, face_up: bool = true):
    print(new_pile, index, face_up)
    var eff_index = maxi(index, 0)
    var to_move = cards.slice(eff_index)
    cards = cards.slice(0, eff_index)
    for card in to_move:
        new_pile.place_card(card, face_up)
    respread = true


func move_n_cards(new_pile: Pile, num_cards: int, face_up: bool = true):
    move_cards_from(new_pile, len(cards) - num_cards, face_up)


func do_spread():
    # eff_spread will always be at least 1 if the list is not empty,
    # so this should never give an out-of-bounds error
    var eff_spread = len(cards) if spread <= 0 else spread
    var thresh = max(0, len(cards) - eff_spread)
    #logger.log(str("Spread: ", eff_spread, ", ", " Thresh: ", thresh))
    var next_position := Vector2.ZERO
    for i in len(cards):
        var card = cards[i]
        var clickable = false
        if not none_clickable:
            if not only_top_card_clickable:
                clickable = i >= thresh and card.target_face_up
            elif i == cards.size() - 1:
                clickable = true
        #print("Card ", card, " in ", self, " clickable = ", clickable)
        card.click_area.input_pickable = clickable
        CardTweener.tween(card, self.to_global(next_position))
        if i >= thresh:
            var offset := face_up_spread_offset if card.target_face_up else face_down_spread_offset
            next_position += offset
    respread = false


func _on_card_input(_viewport: Node, event: InputEvent, _shape_idx: int, card: Card) -> void:
    #logger.log("card % clicked in pile" % card.name)
    if event.is_action("select"):
        clicked_cards.push_back(card)
        clicked_pressed = event.is_pressed()


func _on_pile_input(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
    if event.is_action("select"):
        selected.emit(self, event.is_pressed())
