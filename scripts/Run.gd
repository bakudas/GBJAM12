extends State

func exec() -> void:
	if player.is_on_floor():
		$"../../label_state".text = "Run"
		$"../../anim".play("run")


func get_player(_player):
	player = _player
