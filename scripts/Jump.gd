extends State


func exec() -> void:
	$"../../anim".play("jump")
	$"../../label_state".text = "Jump"


func get_player(_player):
	player = _player
