extends Control


var dialog = {
	1: {
		"title": "Shadow Forest",
		"dialog": [
			"Ninjo Misterio enters 
			the Shadow Forest, where 
			restless spirits wander.", 
			"The first fragment of the 
			portal awaits in the depths 
			of this cursed woodland."
		],
		"screen": "cutscene01",
	}, 
	2: {
		"title": "Abandoned Village",
		"dialog": [
			"The empty streets of 
			the Abandoned Village 
			hide dark secrets", 
			"Ninjo must navigate this 
			labyrinth of lost memories 
			to find the second fragment"
		],
		"screen": "cutscene02",
	},
	3: {
		"title": "Ritual Dungeon",
		"dialog": [
			"The Ritual Cave, 
			the lair of the 
			Herald of Chaos", 
			"Ninjo will face his greatest 
			challenge to seal the portal 
			and save the world from demons"
		],
		"screen": "cutscene03",
	},
}
var actual_dialog: int = 0
var actual_scene: int = 1
var char_count
var text_pos = 0
@export var next_scene:PackedScene
@onready var text = $dialog

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$scene.play(dialog[actual_scene].screen)
	text_pos = 0
	$dialog_confirm.visible = false
	text.text = dialog[actual_scene].dialog[actual_dialog]
	$title.text = dialog[actual_scene].title


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if text.visible_ratio < 1:
		text.visible_ratio += 0.003
	elif text.visible_ratio == 1:
		$dialog_confirm.visible = true
		
	if Input.is_action_just_pressed("start_button"):
		if actual_dialog < dialog[actual_scene].dialog.size() - 1:
			actual_dialog += 1
			text.text = dialog[actual_scene].dialog[actual_dialog]
			text.visible_ratio = 0
		elif actual_dialog == dialog[actual_scene].dialog.size() - 1:
			get_tree().change_scene_to_packed(next_scene)
