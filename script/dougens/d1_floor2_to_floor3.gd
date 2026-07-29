extends Area2D
@export var target_destination: Marker2D 



func _on_body_entered(body: Node2D) -> void:
	if body.name == "user":
		if target_destination != null:
			body.global_position = target_destination.global_position
