extends CharacterBody2D
class_name Player

signal start

const SPEED = 250.0
const JUMP_VELOCITY = -300.0
enum states { IDLE=0, RUN, JUMP, FALL }
var state = states.IDLE
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# Input Handler
@onready var input_handler = $InputHandler
# Player Behaviour
@onready var player_behaviour = $PlayerBehaviourTree
var direction


func _init():
	pass


func _ready():
	emit_signal("start", self)


func _physics_process(delta):
	move_and_slide()
