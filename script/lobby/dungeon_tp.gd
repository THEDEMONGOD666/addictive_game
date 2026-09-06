extends Area2D

var my_scenes = ["res://scene/dungeon .tscn","res://scene/goblin_dungeon.tscn"]




func _on_body_entered(body: Node2D) -> void:
	if body.name == "user":
		var chosen_one = my_scenes.pick_random()
		get_tree().change_scene_to_file(chosen_one)
