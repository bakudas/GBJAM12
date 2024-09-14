extends State


func exec() -> void:
	$"../../label_state".text = "Run"
	player.velocity.x = player.direction * player.SPEED
	$"../../anim".play("run")


func get_player(_player):
	player = _player
