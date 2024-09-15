extends State


func exec() -> void:
	$"../../label_state".text = "Attack"
	$"../../anim".play("attack")

func get_player(_player):
	player = _player
