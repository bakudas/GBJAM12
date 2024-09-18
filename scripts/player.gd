extends CharacterBody2D
class_name Player

signal start

const SPEED = 200.0
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

@export_group("Stats")
@export_range(1.0, 10.0, 1.0) var max_heath:float
@export_range(10.0, 100.0, 1.0) var damage_power:float

# PRIVATE
var current_health:float
var coyote_time = .085 # Tempo em segundos durante o qual o jogador pode pular após sair da plataforma
var coyote_time_counter = 0.0
var jump_pressed = false
var is_on_ground = false

func _ready():
	emit_signal("start", self)
	current_health = max_heath


func _process(delta: float) -> void:
	if current_health <= 0:
		get_tree().reload_current_scene()


func _physics_process(delta):
	move_and_slide()


func receive_damage(amount:float=1):
	current_health = clamp(current_health - amount, 0, max_heath)
	print(current_health)


func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_class("TileMapLayer"): 
		var tile_coords = body.get_coords_for_body_rid(body_rid)
		var tile_data = body.get_cell_tile_data(tile_coords).get_custom_data_by_layer_id(0)
		is_on_ladder = tile_data
