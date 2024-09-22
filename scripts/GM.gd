extends Node

@onready var player
@onready var gui
var player_health
var gui_health

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player != null and gui != null:
		if player_health < gui_health:
			gui_health -= 1
			gui.health_list[player_health].visible = false
		
		if player_health > gui_health:
			gui_health += 1
			gui.health_list[player_health - 1].visible = true
