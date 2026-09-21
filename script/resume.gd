extends Button


func _ready():
		if not FileAccess.file_exists("user://save.dat"):
			hide()


func _on_pressed() -> void:
	Global.load_save()
	get_tree().change_scene_to_file("res://scene/lobby.tscn")
