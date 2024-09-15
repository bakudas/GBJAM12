extends CharacterBody2D
class_name Player

signal start

const SPEED = 8500.0
const JUMP_VELOCITY = -300.0
enum states { IDLE=0, RUN, JUMP, FALL }
var state = states.IDLE
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# Input Handler
@onready var input_handler = $InputHandler
# Player Behaviour
@onready var player_behaviour = $PlayerBehaviourTree
var direction:float
var attack:bool
var is_jumping:bool
var is_on_ladder:bool
var is_attacking:bool


func _init():
	pass


func _ready():
	emit_signal("start", self)


func _physics_process(delta):
	move_and_slide()


func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_class("TileMapLayer"): 
		var tile_coords = body.get_coords_for_body_rid(body_rid)
		var tile_data = body.get_cell_tile_data(tile_coords).get_custom_data_by_layer_id(0)
		is_on_ladder = tile_data
