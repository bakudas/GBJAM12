extends Behaviour
class_name BehaviourTree

# FIELDS
enum PLAYER_STATES { IDLE, RUN, JUMP, FALL, ATTACK, ESPECIAL }
var state : PLAYER_STATES = PLAYER_STATES.IDLE
@onready var player = $".."
@export var disable : bool = false
@export var cur_state : Node
@export var prev_behavior : Node
@onready var NODE_STATES = get_children()
var attack_cooldown: float = 0.20
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
		set_state(PLAYER_STATES.JUMP)
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
	
	if player.attack and can_attack and not player.is_attacking:
		perform_attack()
	if player.direction and not player.is_jumping and not player.is_attacking:
		set_state(PLAYER_STATES.RUN)
		$"../anim".scale.x = player.direction
	else:
		handle_idle_state()

func handle_idle_state():
	player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
	if not player.is_attacking and not player.is_jumping:
		set_state(PLAYER_STATES.IDLE)

func handle_air_state(delta):
	player.is_on_ground = false
	
	if player.coyote_time_counter > 0:
		player.coyote_time_counter -= delta

	if !player.is_on_ladder: # Apply gravity
		player.velocity.y += player.gravity * delta

	if player.attack and can_attack and not player.is_attacking:
		perform_attack()
	elif player.velocity.y > 0 and not player.is_attacking:
		set_state(PLAYER_STATES.FALL)
		player.is_jumping = false

func perform_attack():
	set_state(PLAYER_STATES.ATTACK)
	$"../label_state".text = "Attack"
	$"../anim".play("attack")
	player.is_attacking = true
	can_attack = false
	$"../anim/attack_collider/CollisionShape2D".disabled = false
	await get_tree().create_timer(attack_cooldown).timeout
	player.is_attacking = false
	$"../anim/attack_collider/CollisionShape2D".disabled = true
	can_attack = true
	$"../FmodBankLoader/FmodEventEmitter2D".play()

func handle_state_actions():
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

func set_state(new_state: PLAYER_STATES):
	state = new_state

func change_behaviour(_state: PLAYER_STATES) -> void:
	state = _state
	prev_behavior = cur_state


func get_cur_state() -> String:
	return cur_state.name

func get_player(_player):
	player = _player
