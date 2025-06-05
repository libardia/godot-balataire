class_name Deck
extends Node2D

# ==================================================================================================

@onready
var marker: Sprite2D = $Marker
@onready
var click_area: Area2D = $DeckClickArea

var cards: Array[Card] = []
var card_obj: PackedScene = preload("res://obj/card.tscn")

signal selected

# ==================================================================================================

func _ready() -> void:
    for rank in 13:
        for suit in 4:
            var c: Card = card_obj.instantiate()
            c.rank = rank
            c.suit = suit
            cards.push_back(c)
    cards.shuffle()
    for c in cards:
        marker.add_child(c)


func _on_deck_input(viewport: Node, event: InputEvent, shape_idx: int) -> void:
    if event.is_action_released("select"):
        selected.emit()
