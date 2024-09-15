extends Behaviour
class_name BehaviourTree

enum PLAYER_STATES { IDLE, RUN, JUMP, FALL, ATTACK, ESPECIAL }
var state : PLAYER_STATES
@onready var player = $".."
@export var disable : bool = false
@export var cur_state : Node
@export var prev_behavior : Node
@onready var NODE_STATES = get_children()
var attack_cooldown:float = .25
var can_attack:bool = true


func _ready():
	pass

func _process(delta):
	# get axis input
	player.direction = Input.get_axis("move_left", "move_right")
	player.is_jumping = Input.is_action_just_pressed("jump")
	player.attack = Input.is_action_just_pressed("attack")
	
	# MOVE
	player.velocity.x = player.direction * player.SPEED * delta

	# HANDLING INPUTS
	# GROUND ACTIONS
	if player.is_on_floor():
		if player.direction:
			# JUMP
			if player.is_jumping:
				player.velocity.y = player.JUMP_VELOCITY
				state = PLAYER_STATES.JUMP
			# ATTACK
			elif player.attack and can_attack and !player.is_attacking:
				state = PLAYER_STATES.ATTACK
				$"../label_state".text = "Attack"
				$"../anim".play("attack")
				player.is_attacking = true
				can_attack = false
				$"..//anim/attack_collider/CollisionShape2D".disabled = false
				await get_tree().create_timer(attack_cooldown).timeout
				player.is_attacking = false
				$"..//anim/attack_collider/CollisionShape2D".disabled = true
				can_attack = true
			# RUN
			elif player.direction and !player.is_jumping and !player.is_attacking:
				state = PLAYER_STATES.RUN
				$"../anim".scale.x = player.direction
		# IDLE
		else:
			# RUN
			if player.direction and !player.is_jumping:
				state = PLAYER_STATES.RUN
				$"../anim".scale.x = player.direction
			# ATTACK
			elif player.attack and can_attack and !player.is_attacking:
				state = PLAYER_STATES.ATTACK
				$"../label_state".text = "Attack"
				$"../anim".play("attack")
				player.is_attacking = true
				can_attack = false
				$"../anim/attack_collider/CollisionShape2D".disabled = false
				await get_tree().create_timer(attack_cooldown).timeout
				player.is_attacking = false
				$"..//anim/attack_collider/CollisionShape2D".disabled = true
				can_attack = true
			# JUMP
			elif player.is_jumping:
				player.velocity.y = player.JUMP_VELOCITY
				state = PLAYER_STATES.JUMP
			else:
				player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
				
				if not player.is_attacking:
					state = PLAYER_STATES.IDLE
	# AIR ACTIONS
	else:
		# Add the gravity.
		player.velocity.y += player.gravity * delta
	
		# ATTACK
		if player.attack and can_attack and !player.is_attacking:
			state = PLAYER_STATES.ATTACK
			$"../label_state".text = "Attack"
			$"../anim".play("attack")
			player.is_attacking = true
			can_attack = false
			await get_tree().create_timer(attack_cooldown).timeout
			player.is_attacking = false
			can_attack = true
		elif player.velocity.y > 0 and !player.is_attacking:
			state = PLAYER_STATES.FALL	
	
	match state:
		PLAYER_STATES.IDLE:
			$Idle.exec()
		PLAYER_STATES.RUN:
			$Run.exec()
		PLAYER_STATES.ATTACK:
			$Attack.exec()
		PLAYER_STATES.JUMP when player.is_on_floor():
			$Jump.exec()
		PLAYER_STATES.FALL when !player.is_on_floor():
			$Fall.exec()


func change_behaviour(_state:PLAYER_STATES) -> void:
	state = _state
	prev_behavior = cur_state


func set_state(state:Node) -> bool:
	cur_state = state
	
	if cur_state == null:
		return false
	else:
		return true


func get_cur_state() -> String:
	return cur_state.name


func get_player(_player):
	player = _player
