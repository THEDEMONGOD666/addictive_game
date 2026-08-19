extends CharacterBody2D


@export var speed = 100.0
@export var attack_range = 60.0

var player = null
var is_dead = false

func _physics_process(delta):
	if is_dead == true:
		return
	
	if player != null:
		var distance = global_position.distance_to(player.global_position)
		if distance > attack_range:
			var direction = (player.global_position - global_position).normalized()
			velocity = direction * speed
			move_and_slide()
			
			$AnimatedSprite2D.play("walk")
			if direction.x> 0:
				$AnimatedSprite2D.flip_h = false
			elif direction.x < 0:
				$AnimatedSprite2D.flip_h = true
		else:
			velocity = Vector2.ZERO
			$AnimatedSprite2D.play("attack")
	else:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.play("idel")

#connect done
func _on_detection_area_body_entered(body):
	if body.name == "user": 
		player = body
#connect done
func _on_detection_area_body_exited(body):
	if body.name == "user":
		player = null

func take_damage():
	$AnimatedSprite2D.play("hurt")

func die():
	is_dead = true
	velocity = Vector2.ZERO
	$AnimatedSprite2D.play("death")
