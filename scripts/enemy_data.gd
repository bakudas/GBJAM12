class_name EnemyData

## PROPERTIES
#@export_category("Basic Enemy Settings")
#
#@export_group("Stats")
#@export_range(1.0, 10.0, 1.0) var max_heath:float
#@export_range(1.0, 100.0, 1.0) var damage_power:float
#
#@export_group("Visual")
#@export var animation_frames:SpriteFrames
#
#@export_group("FX")
#
#@export_group("Audio")

const Database = {
	"Big Eye": {
		"sprite": "res://animations/enemy_big_eye_animations.tres",
		"max_health": 1,
		"damage_power": 1,
		"fliped": false
	},
	"Cursed Bat": {
		"sprite": "res://animations/enemy_cursed_bat_animations.tres",
		"max_health": 1,
		"damage_power": 1,
		"fliped": true
	},
}
