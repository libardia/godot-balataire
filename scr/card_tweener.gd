extends Node

const DEFAULT_DURATION: float = 0.2

var active_tweens: Dictionary[int, Tween] = {}

func tween(target: Node2D, final_position: Vector2, duration: float = DEFAULT_DURATION):
    if target.position == final_position:
        # Do nothing if the start and end positions are the same
        return
    var id = target.get_instance_id()
    # Kill tween if one already exists on this target
    if active_tweens.has(id):
        print("killing tweeen with id ", id)
        active_tweens[id].kill()
    # So cards are always rendered on top when moving
    target.z_index = 1
    # Make tween
    var t: Tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
    t.tween_property(target, "position", final_position, duration)
    t.tween_callback(func ():
        # Remove from active tweens
        active_tweens.erase(id)
        # Put card back at 0 z
        target.z_index = 0
    )
    active_tweens[id] = t
