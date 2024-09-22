extends Node


# Called when the node enters the scene tree for the first time.
func exec() -> void:
	$"../../label_state".text = "hit"
	$"../../anim".play("hit")
