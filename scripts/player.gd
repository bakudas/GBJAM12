extends CharacterBody2D
class_name Player

# SIGNALS
signal start

# CONSTANTS
const SPEED = 170.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# Input Handler
@onready var input_handler = $InputHandler
# Player Behaviour
@onready var player_behaviour = $PlayerBehaviourTree
var is_jumping:bool = false
var is_on_ladder:bool = false
var is_attacking:bool = false
var is_hitting:bool = false
var is_on_ground:bool = false

@export_group("Stats")
@export_range(1.0, 12.0, 1.0) var max_heath:float
@export_range(10.0, 100.0, 1.0) var damage_power:float

# PRIVATE
enum PLAYER_STATES { IDLE, RUN, JUMP, FALL, ATTACK, HIT, ESPECIAL }
var state = PLAYER_STATES.IDLE
var previous_state
var current_health:float
var coyote_time = .085 # Tempo em segundos durante o qual o jogador pode pular após sair da plataforma
var coyote_time_counter = 0.0
var direction:float
var attack:bool = false
var jump_pressed = false
var attack_power:float = 1.0
var attack_dir:float


func _init() -> void:
	GameManager.player = self


func _ready():
	emit_signal("start", self)
	current_health = max_heath
	GameManager.player_health = current_health


func _process(delta: float) -> void:
	if current_health <= 0:
		get_tree().reload_current_scene()


func _physics_process(delta):
	move_and_slide()


func receive_damage(amount:float=1):
	current_health = clamp(current_health - amount, 0, max_heath)
	GameManager.player_health = current_health
	is_hitting = true


func recovery_health(amount:float=1):
	current_health = clamp(current_health + amount, 0, max_heath)
	GameManager.player_health = current_health


func knockback():
	pass


func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_class("TileMapLayer"): 
		var tile_coords = body.get_coords_for_body_rid(body_rid)
		var is_on_ladder = body.get_cell_tile_data(tile_coords).get_custom_data_by_layer_id(0) # custom data layer #0
		var is_death = body.get_cell_tile_data(tile_coords).get_custom_data_by_layer_id(1) # custom data layer #1
		var is_on_one_way_platform = body.get_cell_tile_data(tile_coords).get_custom_data_by_layer_id(2) # custom data layer #1
		
		if is_death:
			get_tree().reload_current_scene()
		elif is_on_ladder:
			pass # TODO climb over the ladder
		elif is_on_one_way_platform:
			pass # TODO jump down over the one way platform


func _on_ladder_collider_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("destroy"):
		area.get_parent().destroy()
	recovery_health(1)
