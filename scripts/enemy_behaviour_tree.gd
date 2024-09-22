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
	$"../AnimatedSprite2D".play("hit")
	await get_tree().create_timer(.25).timeout
	$"../AnimatedSprite2D".play("idle")
	

func perform_attack_state() -> void:
	$"../AnimatedSprite2D".play("attack")
	await get_tree().create_timer(.3).timeout
	if !enemy.player_in_area:
		enemy.is_dealing_damage = false


func perform_death_state() -> void:
	$"../hitbox".monitoring = false
	$"../AnimatedSprite2D".play("death")
	await get_tree().create_timer(.3).timeout
	$"../AnimatedSprite2D".stop()
	$"../AnimatedSprite2D".set_frame_and_progress(4, 0.0)
	


func perform_hit_state() -> void:
	$"../AnimatedSprite2D".play("idle")


func perform_patrol_state() -> void:
	$"../AnimatedSprite2D".play("patrol")
