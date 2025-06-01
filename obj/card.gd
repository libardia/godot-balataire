@tool
class_name Card
extends Node2D


var reload = false

@export_enum("2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "Ace")
var rank: int
@export_enum("Hearts", "Clubs", "Diamonds", "Spades")
var suit: int
@export_range(0, 19)
var back: int
@export
var face_up: bool = false
var target_face_up: bool = false

@onready
var face_spr: AtlasSprite = $Face
@onready
var value_spr: AtlasSprite = $Face/Value
@onready
var back_spr: AtlasSprite = $Back
@onready
var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
    update()

func _process(_delta: float) -> void:
    if Engine.is_editor_hint() or reload:
        update()
        target_face_up = face_up
        reload = false
    else:
        if not animation_player.is_playing():
            if target_face_up and not face_up:
                animation_player.play("flip_up")
            elif not target_face_up and face_up:
                animation_player.play_backwards("flip_up")
    face_spr.visible = face_up
    back_spr.visible = not face_up

func update():
    value_spr.atlas_coords = Vector2i(rank, suit)
    back_spr.atlas_coords = CardBacks.BACKS[back]
