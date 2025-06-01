@tool
class_name AtlasSprite
extends Sprite2D


var reload = false

@export
var atlas_source: Texture2D
@export
var margins: Vector2i
@export
var spacing: Vector2i
@export
var size: Vector2i
@export
var atlas_coords: Vector2i


func _ready() -> void:
    update()

func _process(_delta: float) -> void:
    if Engine.is_editor_hint() or reload:
        update()
        reload = false

func update():
    if atlas_source != null:
        if self.texture == null or not self.texture is AtlasTexture:
            self.texture = AtlasTexture.new()
        var a = self.texture
        a.atlas = atlas_source
        a.region = Rect2(
            margins.x + (spacing.x * atlas_coords.x) + (size.x * atlas_coords.x),
            margins.y + (spacing.y * atlas_coords.y) + (size.y * atlas_coords.y),
            size.x, size.y
        )
        self.texture = a
