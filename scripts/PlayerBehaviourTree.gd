extends Behaviour
class_name BehaviourTree

enum PLAYER_STATES { IDLE, RUN, JUMP, FALL }
var state : PLAYER_STATES
@onready var player = $".."
@export var disable : bool = false
@export var cur_state : Node
@export var prev_behavior : Node
@onready var NODE_STATES = get_children()


func _ready():
	pass

func _physics_process(delta):
	# Add the gravity.
	if not player.is_on_floor():
		player.velocity.y += player.gravity * delta
	
	if player.velocity.x == 0:
		state = PLAYER_STATES.IDLE
	
	player.direction = Input.get_axis("ui_left", "ui_right")
	
	if player.direction:
		state = PLAYER_STATES.RUN
		$"../anim".scale.x = player.direction
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
	
	match state:
		PLAYER_STATES.IDLE:
			# Handle jump.
			if Input.is_action_just_pressed("ui_accept"):
				player.velocity.y = player.JUMP_VELOCITY
				state = PLAYER_STATES.JUMP
				$"../label_state".text = "Jump"
				$"../anim".play("jump")
				print("JUMP")
			elif player.velocity.y > 0:
				state = PLAYER_STATES.FALL
				$"../label_state".text = "Fall"
				$"../anim".play("jump")
			elif player.is_on_floor():
				$Idle.exec()

		PLAYER_STATES.RUN:
			# Handle jump.
			if Input.is_action_just_pressed("ui_accept"):
				player.velocity.y = player.JUMP_VELOCITY
				state = PLAYER_STATES.JUMP
				$"../label_state".text = "Jump"
				$"../anim".play("jump")
				print("JUMP")
			elif player.velocity.y > 0:
				state = PLAYER_STATES.FALL
				$"../label_state".text = "Fall"
				$"../anim".play("jump")
			elif player.is_on_floor():
				$Run.exec()
		
		PLAYER_STATES.JUMP:
			$Jump.exec()
			pass
		
		PLAYER_STATES.FALL:
			$Fall.exec()
			pass


func change_behaviour(_state:PLAYER_STATES) -> void:
	state = _state
	prev_behavior = cur_state
	#match state:
		#PLAYER_STATES.IDLE:
			#set_state($Idle)
		#PLAYER_STATES.RUN:
			#set_state($Run)
		#PLAYER_STATES.JUMP:
			#set_state($Jump)
		#PLAYER_STATES.FALL:
			#set_state($Fall)


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
