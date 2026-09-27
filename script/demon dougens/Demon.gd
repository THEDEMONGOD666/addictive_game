extends CharacterBody2D

# Demon settings
const BASE_HEALTH: int = 100
const HEALTH_PER_TIER: int = 20

const BASE_DAMAGE: int = 10
const DAMAGE_PER_TIER: int = 5

const DEFAULT_DAMAGE_TAKEN: int = 20
const ATTACK_RANGE: float = 60.0
const HURT_TIME: float = 0.3

# Soul reward
const SOUL_SCENE = preload("res://scene/soul_orb.tscn")

@export var speed: float = 100.0

@onready var collision_shape = $CollisionShape2D
@onready var health_bar = $ProgressBar
@onready var sprite = $AnimatedSprite2D

var target_player: CharacterBody2D = null
var current_health: int = BASE_HEALTH
var is_dead: bool = false
var is_hurting: bool = false


func _ready() -> void:
	apply_scaling()

	if health_bar:
		health_bar.visible = false
		health_bar.max_value = current_health
		health_bar.value = current_health


func apply_scaling() -> void:
	# The demon gets stronger as the player's gold increases.
	var tier = int(Global.gold / Global.GOLD_PER_TIER)
	current_health = BASE_HEALTH + (tier * HEALTH_PER_TIER)


func _physics_process(_delta: float) -> void:
	if is_dead or is_hurting:
		return

	if target_player == null:
		velocity = Vector2.ZERO
		sprite.play("idle")
		return

	var distance_to_player = global_position.distance_to(target_player.global_position)

	if distance_to_player > ATTACK_RANGE:
		move_towards_player()
	else:
		attack_player()


func move_towards_player() -> void:
	var direction = (target_player.global_position - global_position).normalized()

	velocity = direction * speed
	move_and_slide()

	sprite.play("walk")
	sprite.flip_h = direction.x > 0


func attack_player() -> void:
	velocity = Vector2.ZERO

	if sprite.animation != "attack":
		sprite.play("attack")

		var tier = int(Global.gold / Global.GOLD_PER_TIER)
		var damage = BASE_DAMAGE + (tier * DAMAGE_PER_TIER)

		if target_player.has_method("_receive_damage"):
			target_player._receive_damage(damage)


func _on_detection_area_body_entered(body: Node) -> void:
	if body.has_method("_receive_damage"):
		target_player = body


func _on_detection_area_body_exited(body: Node) -> void:
	if body == target_player:
		target_player = null


func take_damage(damage: int = DEFAULT_DAMAGE_TAKEN) -> void:
	if is_dead:
		return

	current_health -= damage

	if health_bar:
		health_bar.value = current_health
		health_bar.visible = true

	if current_health <= 0:
		die()
		return

	is_hurting = true
	sprite.play("hurt")

	var hurt_timer = get_tree().create_timer(HURT_TIME)
	hurt_timer.timeout.connect(_on_hurt_timeout)


func _on_hurt_timeout() -> void:
	is_hurting = false


func die() -> void:
	is_dead = true
	velocity = Vector2.ZERO

	if health_bar:
		health_bar.visible = false

	if collision_shape:
		collision_shape.disabled = true

	sprite.play("death")

	await sprite.animation_finished

	var soul = SOUL_SCENE.instantiate()
	soul.global_position = global_position

	get_tree().root.add_child(soul)
	queue_free()
