@tool
extends Node2D

@export_enum("Big", "Medium", "Small") var prop_type: String = "Big"
@export_enum("New", "Broken") var prop_condition: String = "New"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		handle_prop_type()

	if not Engine.is_editor_hint():
		handle_prop_type()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func handle_prop_type():
	match prop_type:
		"Big":	
			$AnimatedSprite2D.sprite_frames = load("res://animations/big_pot.tres")
		"Medium":
			$AnimatedSprite2D.sprite_frames = load("res://animations/medium_pot.tres")
		"Small":
			$AnimatedSprite2D.sprite_frames = load("res://animations/small_pot.tres")

	match prop_condition:
		"New":
			$AnimatedSprite2D.play("idle")
		"Broken":
			$AnimatedSprite2D.play("interact")


func _on_area_2d_area_entered(area: Area2D) -> void:
	if !area.is_in_group("player"):
		return
	$Area2D/CollisionShape2D.queue_free()
	if $AnimatedSprite2D.get_animation() == "idle":
		$AnimatedSprite2D.play("interact")
