extends CharacterBody2D

@export var speed: float = 200.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

enum State { NORMAL, ATTACKING, HIT }
var current_state: State = State.NORMAL

func _physics_process(delta: float) -> void:
	match current_state:
		State.NORMAL:
			handle_movement_input()
			handle_animation_normal()
		State.ATTACKING:
			velocity = Vector2.ZERO 
		State.HIT:
			velocity = Vector2.ZERO 

	move_and_slide()
	handle_sprite_direction()

func handle_movement_input() -> void:
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_vector.normalized() * speed

	if Input.is_action_just_pressed("attack"):
		current_state = State.ATTACKING
		animated_sprite.play("attack")
		print("yo")

func handle_animation_normal() -> void:
	if velocity != Vector2.ZERO:
		animated_sprite.play("walk")
		print("yay")
	else:
		animated_sprite.play("idle_1")
		print("hi")
	if not State.ATTACKING and State.HIT:
		if velocity != Vector2.ZERO:
			animated_sprite.play("walk")
		else:
			animated_sprite.play("idle_1")

func handle_sprite_direction() -> void:
	if velocity.x < 0:
		animated_sprite.flip_h = true
	elif velocity.x > 0:
		animated_sprite.flip_h = false

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "attack" or animated_sprite.animation == "get-hit":
		current_state = State.NORMAL 
