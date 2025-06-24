class_name Card
extends Node2D

# ==================================================================================================

@export var rank: Values.Ranks
@export var suit: Values.Suits
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
var clickable: bool = true

signal selected_card(card: Card, pressed: bool)

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


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action(&"select") and clickable:
        if face_spr.get_rect().has_point(to_local(event.position)):
            selected_card.emit(self, event.is_pressed())
            print("rect-based click event")
