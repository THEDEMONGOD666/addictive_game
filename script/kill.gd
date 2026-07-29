extends Sprite2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("user"):
		get_tree().reload_current_scene()
