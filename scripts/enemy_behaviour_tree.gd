extends Node

@onready var enemy = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handling_states()


func handling_states() -> void:
	match enemy.enemy_state:
		enemy.STATES.IDLE:
			perform_hit_state()
		enemy.STATES.ATTACK:
			perform_attack_state()
		enemy.STATES.DEATH:
			perform_death_state()
		enemy.STATES.HIT:
			perform_idle_state()
		enemy.STATES.PATROL:
			perform_patrol_state()


func perform_idle_state() -> void:
	$"../AnimatableBody2D/AnimatedSprite2D".play("hit")
	await get_tree().create_timer(.25).timeout
	$"../AnimatableBody2D/AnimatedSprite2D".play("idle")
	

func perform_attack_state() -> void:
	pass


func perform_death_state() -> void:
	$"../AnimatableBody2D/AnimatedSprite2D".play("death")
	


func perform_hit_state() -> void:
	$"../AnimatableBody2D/AnimatedSprite2D".play("idle")


func perform_patrol_state() -> void:
	pass
