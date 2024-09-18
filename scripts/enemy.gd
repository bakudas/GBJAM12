extends Node2D
class_name Enemy

# INTERFACES
var implements = Interface.IDamage


# SIGNALS
signal damage_receive
signal damage_apply


# ENUMS
enum ENEMY_TYPE {BAT, BAT_BOMB, ZOMBIE, SKELETON, SKELETON_ARCHER, SPIKE_BOMB, BIG_EYE}
enum DAMAGE_TYPE {NORMAL=0, FIRE, ELETRIC, SHADOW}

# PROPERTIES
@export_category("Basic Enemy Settings")
@export_group("Type")
#@export var enemy_type:ENEMY_TYPE
@export var damage_type:DAMAGE_TYPE
@export_enum("Big Eye", "Cursed Bat", "Spike Bomb") var enemy_name: String = "Big Eye"

@export_group("Stats")
@export_range(1.0, 10.0, 1.0) var max_heath:float
@export_range(10.0, 100.0, 1.0) var damage_power:float

# PRIVATE
var current_health:float
var time:float = 0
var is_moving:bool = true


func _ready() -> void:
	# Setup enemy base on enemy name in EnemyData database
	max_heath = EnemyData.Database[enemy_name].max_health
	current_health = max_heath
	damage_power = EnemyData.Database[enemy_name].damage_power
	var sprite_frames = load(EnemyData.Database[enemy_name].sprite)
	if sprite_frames != null:
		$AnimatableBody2D/AnimatedSprite2D.sprite_frames = sprite_frames
		$AnimatableBody2D/AnimatedSprite2D.play("idle")


func _process(delta):
	pass


func _physics_process(delta: float) -> void:
	if is_moving:
		time += delta
		position.y += sin(time * 3) * 1


func _get_configuration_warnings():
	if max_heath < 0:
		return ["Energy must be 0 or greater."]
	else:
		return []


func receive_damage(cur_health, type, amount:float=1) -> float:
		var new_health:float
		
		new_health = clamp(cur_health - amount, 0, max_heath)
		
		return new_health


func apply_damage(type, amount:float=1):
		pass


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		print("player")
		
	current_health = receive_damage(current_health, implements.DAMAGE_TYPE.NORMAL)
	
	if current_health <= 0:
		is_moving = false
		$AnimatableBody2D/AnimatedSprite2D.play("death")
		await get_tree().create_timer(.25).timeout
		queue_free()
	else:
		$AnimatableBody2D/AnimatedSprite2D.play("hit")
		await get_tree().create_timer(.15).timeout
		$AnimatableBody2D/AnimatedSprite2D.play("idle")


func _on_hitbox_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	
	if body.has_method("receive_damage"):
		body.receive_damage(damage_power)
