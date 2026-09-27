extends Area2D

var amount: int = 3
var can_pickup: bool = false

@onready var sprite = $AnimatedSprite2D


func _ready() -> void:
	sprite.play("new_animation")
	body_entered.connect(picked_up)
	# Short delay before pickup is allowed
	await get_tree().create_timer(Global.SOUL_DELAY).timeout
	can_pickup = true


func picked_up(body: Node) -> void:
	if can_pickup:
		Global.souls += amount
		queue_free()
