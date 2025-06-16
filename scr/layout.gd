extends Node

# ==================================================================================================

const ITEM_SIZE = Vector2(69, 93)
const ITEM_SIZE_H = ITEM_SIZE / 2
const VERTICAL_MAX = 50
const VERTICAL_MIN = 0

@onready var topRow: Node2D = $TopRow
@onready var mainPiles: Node2D = $MainPiles

var spacing: float = 0

# ==================================================================================================

func _ready() -> void:
    do_layout()
    get_viewport().size_changed.connect(do_layout)


func do_layout():
    layout_row(topRow)
    var effective_space = clampf(spacing, VERTICAL_MIN, VERTICAL_MAX)
    topRow.position.x = 0
    topRow.position.y = round(effective_space + ITEM_SIZE_H.y)
    layout_row(mainPiles)
    mainPiles.position.x = 0
    mainPiles.position.y = round(effective_space * 2 + ITEM_SIZE_H.y * 3)


func layout_row(containerNode: Node2D):
    var n = containerNode.get_child_count()
    var total_width = get_viewport().get_visible_rect().size.x
    spacing = (total_width - ITEM_SIZE.x * n) / (n + 1)
    for i in n:
        var child = containerNode.get_child(i) as Node2D
        var x_raw = (i + 1) * spacing + i * ITEM_SIZE.x + ITEM_SIZE_H.x
        child.position.x = roundf(x_raw)
        child.position.y = 0
