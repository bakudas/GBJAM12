extends Node2D

var time:float = 0
var is_moving:bool = true

func _physics_process(delta: float) -> void:
	if is_moving:
		time += delta
		position.y += sin(time * 3) * 1
 

func _on_hitbox_area_entered(area: Area2D) -> void:
	is_moving = false
	$AnimatableBody2D/AnimatedSprite2D.play("death")
	await get_tree().create_timer(.25).timeout
	queue_free()
