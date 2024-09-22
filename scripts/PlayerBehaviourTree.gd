extends Behaviour
class_name BehaviourTree

# FIELDS
@onready var player = $".."
@export var disable : bool = false
@onready var NODE_STATES = get_children()
var attack_cooldown: float = 0.15
var can_attack: bool = true

func _ready():
	pass

func _physics_process(delta):
	handle_input()
	update_player_state(delta)
	handle_state_actions()

func handle_input():
	player.direction = Input.get_axis("move_left", "move_right")
	player.attack = Input.is_action_just_pressed("attack")
	if Input.is_action_just_pressed("jump"):
		player.jump_pressed = true

func update_player_state(delta):
	# Update horizontal velocity
	player.velocity.x = player.direction * player.SPEED

	# Handle Jump
	if player.jump_pressed and (player.is_on_floor() or player.coyote_time_counter > 0):
		player.is_jumping = true
		change_behaviour(player.PLAYER_STATES.JUMP)
		$"../anim".play("jump")
		$"../label_state".text = "Jump"
		player.jump_pressed = false
		player.coyote_time_counter = 0
		player.velocity.y = player.JUMP_VELOCITY
	
	# Ground state handling
	if player.is_on_floor():
		handle_ground_state()
	else:
		handle_air_state(delta)

func handle_ground_state():
	player.is_on_ground = true
	player.coyote_time_counter = player.coyote_time
	
	if player.attack and can_attack and not player.is_hitting and not player.is_attacking:
		perform_attack()
	
	if player.direction and not player.is_jumping and not player.is_attacking and not player.is_hitting:
		change_behaviour(player.PLAYER_STATES.RUN)
		player.attack_dir = player.direction
		$"../anim".scale.x = player.direction
	elif player.is_hitting:
		change_behaviour(player.PLAYER_STATES.HIT)
		await get_tree().create_timer(.2).timeout
		player.is_hitting = false
		change_behaviour(player.PLAYER_STATES.IDLE)
	else:
		handle_idle_state()

func handle_idle_state():
	player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
	if not player.is_attacking and not player.is_jumping:
		change_behaviour(player.PLAYER_STATES.IDLE)

func handle_air_state(delta):
	player.is_on_ground = false
	
	if player.coyote_time_counter > 0:
		player.coyote_time_counter -= delta

	if !player.is_on_ladder: # Apply gravity
		player.velocity.y += player.gravity * delta

	if player.attack and can_attack and not player.is_attacking and not player.is_hitting:
		perform_attack()
	elif player.velocity.y > 0 and not player.is_attacking and not player.is_hitting:
		change_behaviour(player.PLAYER_STATES.FALL)
		player.is_jumping = false
	elif player.is_hitting:
		change_behaviour(player.PLAYER_STATES.HIT)
		await get_tree().create_timer(.2).timeout
		player.is_hitting = false
		change_behaviour(player.PLAYER_STATES.IDLE)

func perform_attack():
	$"../FmodBankLoader/FmodEventEmitter2D".play()
	
	change_behaviour(player.PLAYER_STATES.ATTACK)
	
	$"../label_state".text = "Attack"
	$"../anim".play("attack")
	
	player.is_attacking = true
	can_attack = false
	
	$"../anim/attack_collider/CollisionShape2D".disabled = false
	
	await get_tree().create_timer(attack_cooldown).timeout
	
	$"../anim/attack_collider/CollisionShape2D".disabled = true
	
	player.is_attacking = false
	can_attack = true
	

func handle_state_actions():
	match player.state:
		player.PLAYER_STATES.IDLE:
			$Idle.exec()
		player.PLAYER_STATES.RUN:
			$Run.exec()
		player.PLAYER_STATES.HIT:
			$Hit.exec()
		player.PLAYER_STATES.ATTACK:
			$Attack.exec()
		player.PLAYER_STATES.JUMP when player.is_on_floor():
			$Jump.exec()
		player.PLAYER_STATES.FALL when !player.is_on_floor():
			$Fall.exec()


func change_behaviour(new_state) -> void:
	player.previous_state = player.state
	player.state = new_state


func get_cur_state() -> String:
	return player.state.name

func get_player(_player):
	player = _player
