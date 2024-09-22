extends Node

@onready var player: CharacterBody2D = $"../player"
@onready var gui : Control = $"../CanvasLayer/GUI"

# Called when the node enters the scene tree for the first time.
func _ready():
	gui.health = player.current_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.current_health < gui.health:
		gui.health -= 1
		gui.health_list[player.current_health].visible = false
	
	if player.current_health > gui.health:
		gui.health += 1
		gui.health_list[player.current_health - 1].visible = true
