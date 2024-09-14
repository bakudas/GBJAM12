extends State


func exec() -> void:
	player.velocity.y = player.JUMP_VELOCITY
	$"../anim".play("jump")


func get_player(_player):
	player = _player
