extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "user":
		get_tree().call_group("soul", "queue_free")
		get_tree().change_scene_to_file("res://scene/lobby.tscn")
