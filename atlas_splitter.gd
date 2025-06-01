@tool
extends Node

# ==================================================================================================

@export
var atlas_source: Texture2D
@export
var margins: Vector2i
@export
var spacing: Vector2i
@export
var size: Vector2i
@export
var grid_size: Vector2i

@export_category("Check box to split")
@export
var run: bool = false

# ==================================================================================================

func _process(_delta: float) -> void:
    if run:
        run = false
        for x in grid_size.x:
            for y in grid_size.y:
                var atlas = AtlasTexture.new()
                atlas.atlas = atlas_source
                atlas.region = Rect2(
                    margins.x + (spacing.x * x) + (size.x * x),
                    margins.y + (spacing.y * y) + (size.y * y),
                    size.x, size.y
                )
                var filename = str(atlas_source.resource_path, "-", x, "-", y, ".tres")
                ResourceSaver.save(atlas, filename, ResourceSaver.FLAG_RELATIVE_PATHS)
