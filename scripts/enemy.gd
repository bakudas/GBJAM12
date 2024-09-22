@tool
extends CharacterBody2D
class_name Enemy

# INTERFACES
var implements = Interface.IDamage


# SIGNALS
signal damage_receive
signal damage_apply


# ENUMS
enum ENEMY_TYPE {BAT, BAT_BOMB, ZOMBIE, SKELETON, SKELETON_ARCHER, SPIKE_BOMB, BIG_EYE}
enum DAMAGE_TYPE {NORMAL=0, FIRE, ELETRIC, SHADOW}
enum MOVEMENT_TYE {SIN, HORIZONTAL, FLY, BULLET}
enum STATES {IDLE=0, ATTACK, DEATH, HIT, PATROL}


# PROPERTIES
@export_category("Basic Enemy Settings")
@export_group("Type")
#@export var enemy_type:ENEMY_TYPE
@export var damage_type:DAMAGE_TYPE
@export_enum("Big Eye", "Cursed Bat", "Spike Ball", "Skeleton Melee") var enemy_name: String = "Big Eye"
@export var movement_type:MOVEMENT_TYE

@export_group("Stats")
@export_range(1.0, 10.0, 1.0) var max_heath:float = 12
@export_range(10.0, 100.0, 1.0) var damage_power:float


# PRIVATE
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var enemy_state:STATES = STATES.IDLE
var current_health:float
var time:float = 0
var is_chasing:bool = false
var is_dead:bool = false
var is_dealing_damage:bool = false
var taking_damage:bool = false
var is_roaming:bool = false
var is_flying:bool = false
var speed_h:float = 40
var dir:Vector2 = Vector2(1, 0)
var knockback_force:float
var player:CharacterBody2D
var player_in_area:bool = false
var death_time:float


func _ready() -> void:
	current_health = max_heath
	# Setup enemy base on enemy name in EnemyData database
	speed_h = EnemyData.Database[enemy_name].speed_h
	max_heath = EnemyData.Database[enemy_name].max_health
	damage_power = EnemyData.Database[enemy_name].damage_power
	is_flying = EnemyData.Database[enemy_name].air_type
	death_time = EnemyData.Database[enemy_name].death_time
	$AnimatedSprite2D.flip_h = EnemyData.Database[enemy_name].fliped
	var sprite_frames = load(EnemyData.Database[enemy_name].sprite)
	
	if sprite_frames != null:
		$AnimatedSprite2D.sprite_frames = sprite_frames
		$AnimatedSprite2D.play("idle")


func _process(delta):
	if Engine.is_editor_hint():
		pass

	if not Engine.is_editor_hint():
		# Code to execute in game
		if !is_on_floor() and !is_flying:
			velocity.y += gravity * delta
			velocity.x = 0
		
		# RAYCAST 
		var raycast = $AnimatedSprite2D/RayCast2D
		if raycast.is_colliding():
			if !raycast.get_collider().is_in_group("player"):
				return
			is_chasing = true
			player = raycast.get_collider()
			var distance_to_player = 0
		else:
			is_chasing = false
			player = null
		
		if !is_dead:
			move(delta)
			move_and_slide()


func move(delta):
	if !is_dead:
		if !is_chasing:
			velocity += dir * speed_h * delta
		elif is_chasing and !enemy_state == STATES.HIT and player != null and !is_dealing_damage:
			var direction_to_player = position.direction_to(player.position) * speed_h 
			velocity.x = direction_to_player.x
			dir.x = abs(velocity.x) / velocity.x
			$AnimatedSprite2D.scale.x = -dir.x
			enemy_state = STATES.PATROL
		else:
			player = null
		is_roaming = true
	elif is_dead:
		velocity.x = 0 


func _physics_process(delta: float) -> void:
	pass


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
		current_health = receive_damage(current_health, implements.DAMAGE_TYPE.NORMAL)
		
		if current_health <= 0:
			is_dead = true
			is_roaming = false
			enemy_state = STATES.DEATH
			if !enemy_name == "Skeleton Melee":
				await get_tree().create_timer(death_time).timeout
				queue_free()
				
		else:
			enemy_state = STATES.HIT
			await get_tree().create_timer(.25).timeout
			enemy_state = STATES.IDLE


func _on_hitbox_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	
	if body.has_method("receive_damage"):
		body.receive_damage(damage_power)


func _on_direction_timer_timeout() -> void:
	$DirectionTimer.wait_time = [1, 1.5, 2, 2.5].pick_random()
	if !is_chasing and !is_dead and !is_dealing_damage:
		enemy_state = STATES.PATROL
		dir = [Vector2.RIGHT, Vector2.LEFT].pick_random()
		$AnimatedSprite2D.scale.x = -dir.x
		velocity.x = 0


func _on_attack_area_body_entered(body: Node2D) -> void:
	if !is_dead:
		is_dealing_damage = true
		player_in_area = true
		enemy_state = STATES.ATTACK


func _on_attack_area_body_exited(body: Node2D) -> void:
	player_in_area = false
