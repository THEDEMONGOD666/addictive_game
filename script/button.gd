extends Button

func _on_pressed() -> void:
		var error = get_tree().change_scene_to_file("res://scene/lobby.tscn")
