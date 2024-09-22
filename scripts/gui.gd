extends Control


var health_list = []
var health


func _init() -> void:
	GameManager.gui = self


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_list = $HBoxContainer2.get_children()
	GameManager.gui_health = health_list.size()
	

func _process(delta: float) -> void:
	health = GameManager.gui_health
