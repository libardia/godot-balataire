class_name Deck
extends Pile

# ==================================================================================================

var card_obj: PackedScene = preload("res://obj/card.tscn")

# ==================================================================================================

func _ready() -> void:
    var new_cards = []
    for rank in Values.Ranks.values():
        for suit in Values.Suits.values():
            var c: Card = card_obj.instantiate()
            c.rank = rank
            c.suit = suit
            c.name = str("Card-", rank, "-", suit)
            new_cards.push_back(c)
    new_cards.shuffle()
    for c in new_cards:
        add_child(c)
        place_card(c, false)


func _on_deck_input(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
    if event.is_action_released("select"):
        selected.emit()


func draw_n(to_pile: Pile, n: int, face_up: bool):
    for _i in n:
        var card = cards.pop_back()
        to_pile.place_card(card, face_up)
        respread = true
