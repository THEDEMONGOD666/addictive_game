extends Button

func _on_pressed() -> void:
	Global.wipe_save()
	get_tree().change_scene_to_file("res://scene/lobby.tscn")
