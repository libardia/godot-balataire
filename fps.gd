extends Label

var format_text: String

func _ready() -> void:
    format_text = text

func _process(_delta: float) -> void:
    text = format_text % Engine.get_frames_per_second()
