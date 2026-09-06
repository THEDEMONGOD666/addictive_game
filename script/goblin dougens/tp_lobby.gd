extends Area2D


# Called when the node enters the scene tree for the first time.

func _on_body_entered(body: Node2D) -> void:
	if body.name == "user":
		var error = get_tree().change_scene_to_file("res://scene/lobby.tscn")
