extends Area2D
@export var canvas_layer: CanvasLayer
func _on_body_entered(body: Node2D) -> void:
	if body.name == "user":
		if canvas_layer:
			canvas_layer.visible = true
			


func _on_body_exited(body: Node2D) -> void:
	if body.name=="user":
		if canvas_layer:
			canvas_layer.visible = false
