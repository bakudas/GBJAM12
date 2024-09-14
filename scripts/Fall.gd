extends State


func exec() -> void:
	$"../../label_state".text = "Fall"
	$"../../anim".play("jump")

func get_player(_player):
	player = _player
