extends CharacterBody2D

# Player settings
const BASE_HEALTH: int = 100
const BASE_ATTACK_DAMAGE: int = 10
const STRENGTH_DAMAGE_BONUS: int = 5
const HEALTH_UPGRADE_AMOUNT: int = 10
const SPEED_UPGRADE_AMOUNT: int = 20
const HEAL_AMOUNT: int = 2

@export var speed: float = 200.0
@export var health_ui: Node

var health: int = BASE_HEALTH
var is_attacking: bool = false
var is_stunned: bool = false

@onready var animated_sprite = $AnimatedSprite2D
@onready var attack_area = $Area2D
@onready var walking_sound = $"../walk"
@onready var sword_sound = $"../sword"

func _ready() -> void:
	# Apply the player's upgrades when the game starts.
	speed += Global.speed_level * SPEED_UPGRADE_AMOUNT
	health += Global.health_level * HEALTH_UPGRADE_AMOUNT

	update_ui()


func _physics_process(_delta: float) -> void:
	handle_movement()
	handle_facing_direction()
	handle_attack_input()

	move_and_slide()


func handle_movement() -> void:
	# The player cannot move while attacking or stunned.
	if is_attacking or is_stunned:
		velocity = Vector2.ZERO
		return

	var input_vector = Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
		"ui_down"
	)

	velocity = input_vector.normalized() * speed

	if velocity != Vector2.ZERO:
		animated_sprite.play("walk")
		if not walking_sound.playing:
			walking_sound.play()
	else:
		animated_sprite.play("idle_1")
		walking_sound.stop()


func handle_facing_direction() -> void:
	# Face the player towards the mouse cursor.
	if is_stunned:
		return

	if get_global_mouse_position().x < global_position.x:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false


func handle_attack_input() -> void:
	if Input.is_action_just_pressed("attack"):
		if not is_attacking and not is_stunned:
			execute_attack()


func execute_attack() -> void:
	is_attacking = true
	animated_sprite.play("attack")
	sword_sound.play()
	
	# Find every body inside the attack area.
	var targets = attack_area.get_overlapping_bodies()

	for body in targets:
		if body == self:
			continue

		if body.has_method("take_damage"):
			var damage = BASE_ATTACK_DAMAGE
			damage += Global.strength_level * STRENGTH_DAMAGE_BONUS
			body.take_damage(damage)


func _receive_damage(damage_amount: int) -> void:
	# Ignore damage while stunned or after the player has died.
	if is_stunned or health <= 0:
		return

	health -= damage_amount
	update_ui()

	if health <= 0:
		# Delete the save and close the game when the player dies.
		Global.wipe_save()
		get_tree().quit()
		return

	# Stun the player after taking damage.
	is_stunned = true
	is_attacking = false
	animated_sprite.play("get-hit")

	var stun_timer = get_tree().create_timer(Global.STUN_TIME)
	stun_timer.timeout.connect(_on_stun_timeout)


func _on_stun_timeout() -> void:
	is_stunned = false


func _on_healing_timer_timeout() -> void:
	# Slowly heal the player while they are not stunned.
	if health > 0 and health < BASE_HEALTH and not is_stunned:
		health += HEAL_AMOUNT

		if health > BASE_HEALTH:
			health = BASE_HEALTH

		update_ui()


func update_ui() -> void:
	if health_ui:
		health_ui.max_value = BASE_HEALTH
		health_ui.value = health


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "attack":
		is_attacking = false
