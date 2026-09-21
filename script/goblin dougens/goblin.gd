extends CharacterBody2D

@export var speed: float = 200.0
@export var attack_range: float = 60.0
@onready var collision_shape = $CollisionShape2D

var soul_scene = preload("res://scene/soul_orb.tscn")
var target_player: CharacterBody2D = null
var current_health: int = 100
var is_dead: bool = false
var is_hurting: bool = false

@onready var health_bar = $ProgressBar
@onready var sprite = $AnimatedSprite2D

func _ready() -> void:
	apply_scaling()
	if health_bar:
		health_bar.visible = false
		health_bar.max_value = current_health
		health_bar.value = current_health

func apply_scaling():
	var tier = int(Global.gold / 100)
	current_health = 100 + (tier * 20)

func _physics_process(delta: float) -> void:
	
	target_player._receive_damage(5 + (int(Global.gold / 100) * 3))
	speed = 200 + (int(Global.gold / 100) * 20)

	if is_dead == true:
		return
	if is_hurting == true:
		return 
	if target_player != null:
		var distance = global_position.distance_to(target_player.global_position)
		if distance > attack_range:
			var direction = (target_player.global_position - global_position).normalized()
			velocity = direction * speed
			move_and_slide()
			
			sprite.play("run")
			sprite.flip_h = direction.x < 0
		else:
			velocity = Vector2.ZERO
			
			if sprite.animation != "attack":
				sprite.play("attack")
				if target_player.has_method("_receive_damage"):
					target_player._receive_damage(5)
	else:
		velocity = Vector2.ZERO
		sprite.play("idle")

func _on_detection_area_body_entered(body: Node) -> void:
	if body.has_method("_receive_damage"):
		target_player = body
		
func _on_detection_area_body_exited(body: Node) -> void:
	if body == target_player:
		target_player = null

func take_damage() -> void:
	if is_dead == true:
		return
		
	current_health -= 20 
	
	if health_bar:
		health_bar.value = current_health
		health_bar.visible = true
		
	if current_health <= 0:
		die()
	else:
		is_hurting = true
		sprite.play("hurt")
		
		var hurt_timer = get_tree().create_timer(0.3)
		hurt_timer.timeout.connect(_on_hurt_timeout)

func _on_hurt_timeout() -> void:
	is_hurting = false

func die() -> void:
	is_dead = true
	velocity = Vector2.ZERO
	if health_bar:
		health_bar.visible = false
	sprite.play("death")
	if collision_shape:
		collision_shape.disabled = true
	await sprite.animation_finished
	var soul = soul_scene.instantiate()
	soul.global_position = global_position
	get_tree().root.add_child(soul)  # change this line
	print("soul spawned at: " + str(global_position))
	queue_free()
		
