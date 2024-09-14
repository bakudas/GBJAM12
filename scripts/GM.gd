extends Node

var sqlite : SQLite

# Called when the node enters the scene tree for the first time.
func _ready():
	
	sqlite = SQLite.new()
	sqlite.path = "res://data.db"
	sqlite.open_db()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
