extends Node

func delay_fire(delay: float, callable: Callable):
    get_tree().create_timer(delay).timeout.connect(callable)
