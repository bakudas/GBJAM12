extends State


func exec() -> void:
	$"../../label_state".text = "Idle"
	$"../../anim".play("idle")

func get_player(_player):
	player = _player
