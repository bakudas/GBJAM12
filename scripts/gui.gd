extends Control


var health_list = []
var health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_list = $HBoxContainer2.get_children()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
