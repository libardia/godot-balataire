class_name Spacer
extends Node2D

## The direction the child objects will be spread in.
enum Direction {
    HORIZONTAL, ## Wgad
    VERTICAL
}
enum RecalculateMode { ONCE, ON_SCREEN_RESIZE, CONTINUOUSLY }

# ==================================================================================================

## Test
@export var direction: Direction = Direction.HORIZONTAL
@export var item_size: float = 0
@export var recalculate: RecalculateMode = RecalculateMode.ONCE
@export var round_to_pixel: bool = false
@export var match_nested_spacing: bool = false

var spacing: float = 0

# ==================================================================================================

func _ready() -> void:
    calc_spacing()
    if recalculate == RecalculateMode.ON_SCREEN_RESIZE:
        get_viewport().size_changed.connect(calc_spacing)


func _process(_delta: float) -> void:
    if recalculate == RecalculateMode.CONTINUOUSLY:
        calc_spacing()


func calc_spacing():
    var is_horz = direction == Direction.HORIZONTAL
    var vp = get_viewport().get_visible_rect().size
    var total_space = vp.x if is_horz else vp.y
    var n = self.get_child_count()
    spacing = (total_space - (n * item_size)) / (n + 1)
    for i in n:
        var child = get_child(i)
        if child is Node2D:
            var value = ((i+1) * spacing) + (i * item_size) + (item_size / 2)
            var vec: Vector2 = (Vector2.RIGHT if is_horz else Vector2.DOWN) * value
            if round_to_pixel:
                vec = vec.round()
            (child as Node2D).position = vec
        else:
            push_warning("The child of a Spacer node is not a Node2D!")
