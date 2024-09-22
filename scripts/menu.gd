extends Control

@export var next_scene: PackedScene

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("start_button"):
		get_tree().change_scene_to_packed(next_scene)
