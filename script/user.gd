extends CharacterBody2D

@export var speed: float = 200.0
@export var health_ui: Node

var health: int = 100
var is_attacking: bool = false
var is_stunned: bool = false

@onready var animated_sprite = $AnimatedSprite2D
@onready var attack_area = $Area2D

func _ready() -> void:
	update_ui()
func _physics_process(delta: float) -> void:
	if is_attacking == true or is_stunned == true:
		velocity = Vector2.ZERO
	else:
		var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		velocity = input_vector.normalized() * speed
		
		if velocity != Vector2.ZERO:
			animated_sprite.play("walk")
		else:
			animated_sprite.play("idle_1")
			

	move_and_slide()
	if is_stunned == false:
		if get_global_mouse_position().x < global_position.x:
			animated_sprite.flip_h = true
		else:
			animated_sprite.flip_h = false
	if Input.is_action_just_pressed("attack"):
		if is_attacking == false and is_stunned == false:
			execute_attack()

func execute_attack() -> void:
	is_attacking = true
	animated_sprite.play("attack")
	var targets = attack_area.get_overlapping_bodies()
	print("DIE")
	for body in targets:
		if body == self:
			continue
		if body.has_method("take_damage"):
			body.take_damage()

func _receive_damage(damage_amount: int) -> void:
	if is_stunned == true or health <= 0:
		return 
	health -= damage_amount
	update_ui()
	
	if health <= 0:
		Global.wipe_save()
		get_tree().reload_current_scene()
	
	else:
		is_stunned = true
		is_attacking = false
		animated_sprite.play("get-hit")
		var stun_timer = get_tree().create_timer(0.5)
		stun_timer.timeout.connect(_on_stun_timeout)

func _on_stun_timeout() -> void:
	is_stunned = false

func _on_healing_timer_timeout() -> void:
	if health > 0 and health < 100 and is_stunned == false:
		health += 2
		if health > 100:
			health = 100
		update_ui()

func update_ui() -> void:
	if health_ui:
		health_ui.max_value = 100
		health_ui.value = health
func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "attack":
		is_attacking = false
