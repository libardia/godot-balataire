class_name Card
extends Node2D

# ==================================================================================================

@export_enum("2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "Ace")
var rank: int
@export_enum("Hearts", "Clubs", "Diamonds", "Spades")
var suit: int
@export_range(0, 19) var back: int
@export var face_up: bool = false
@export var animation_time: float = 1

@onready var face_spr: Sprite2D = $Face
@onready var value_spr: Sprite2D = $Face/Value
@onready var back_spr: Sprite2D = $Back
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var click_area: Area2D = $CardClickArea

var target_face_up: bool = false
var pile: Pile = null
var pile_index: int = 0

# ==================================================================================================

func _ready() -> void:
    target_face_up = face_up
    value_spr.texture = ValueMap.VALUE_SPRITES[[rank, suit]]


func _process(_delta: float) -> void:
    if not animation_player.is_playing():
        if target_face_up and not face_up:
            animation_player.play("flip_up", -1, 1 / animation_time, false)
        elif not target_face_up and face_up:
            animation_player.play("flip_up", -1, -1 / animation_time, true)
    face_spr.visible = face_up
    back_spr.visible = not face_up
