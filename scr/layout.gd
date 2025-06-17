extends Node

# ==================================================================================================

@export var reference_texture: Texture2D = null
@export var vertical_max: float = 50
@export var vertical_min: float = 0

@onready var topRow: Node2D = $TopRow
@onready var mainPiles: Node2D = $MainPiles

var item_size: Vector2 = Vector2.ZERO
var item_size_h: Vector2 = Vector2.ZERO
var spacing: float = 0

# ==================================================================================================

func _ready() -> void:
    item_size = reference_texture.get_size()
    item_size_h = item_size / 2
    do_layout()
    get_viewport().size_changed.connect(do_layout)


func do_layout():
    layout_row(topRow)
    var effective_space = clampf(spacing, vertical_min, vertical_max)
    topRow.position = Vector2(0, roundf(effective_space + item_size_h.y))
    layout_row(mainPiles)
    mainPiles.position = Vector2(0, roundf(effective_space * 2 + item_size_h.y * 3))


func layout_row(containerNode: Node2D):
    var n = containerNode.get_child_count()
    var total_width = get_viewport().get_visible_rect().size.x
    spacing = (total_width - item_size.x * n) / (n + 1)
    for i in n:
        var child = containerNode.get_child(i) as Node2D
        var x_raw = (i + 1) * spacing + (2 * i + 1) * item_size_h.x
        child.position = Vector2(roundf(x_raw), 0)
