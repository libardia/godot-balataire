class_name Deck
extends Node2D

# ==================================================================================================

@onready
var marker: Sprite2D = $Marker

var cards: Array[Card] = []
var card_obj: PackedScene = preload("res://obj/card.tscn")

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
