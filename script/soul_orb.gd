extends Area2D

var amount = 3
var can_pickup = false
@onready var sprite = $AnimatedSprite2D
func _ready():
	sprite.play("new_animation")
	print("soul orb exists at: " + str(global_position))
	body_entered.connect(picked_up)
	await get_tree().create_timer(0.3).timeout
	can_pickup = true

func picked_up(body):
	if can_pickup:
		Global.souls += amount
		queue_free()
