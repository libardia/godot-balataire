extends Node

@onready var topRow: Node = $TopRow
@onready var mainPiles: Node = $MainPiles

func _ready() -> void:
    do_layout()
    get_viewport().size_changed.connect(do_layout)

func do_layout() -> void:
    pass
