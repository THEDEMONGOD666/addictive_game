extends Node

# Save file
const SAVE_FILE_PATH: String = "user://save.dat"

# Player starting stats
const STARTING_HEALTH: int = 100
const STARTING_SPEED: float = 200.0
const HEAL_AMOUNT: int = 2

# Enemy stats
const ENEMY_DAMAGE_TAKEN: int = 20
const ENEMY_TIER_HEALTH_BONUS: int = 20
const ENEMY_TIER_SPEED_BONUS: float = 20.0

const GOBLIN_BASE_DAMAGE: int = 5
const GOBLIN_TIER_DAMAGE: int = 3

const DEMON_BASE_DAMAGE: int = 10
const DEMON_TIER_DAMAGE: int = 5

# Soul orb settings
const SOUL_DROP_AMOUNT: int = 3
const SOUL_DELAY: float = 0.3

# Economy settings
const BANK_INTEREST_RATE: float = 1.05
const DEBT_RATE: float = 1.10
const DEBT_DEDUCTION: float = 0.20
const UPGRADE_COST_MULTIPLIER: float = 1.5
const GOLD_PER_TIER: int = 100

const STARTING_UPGRADE_COST: int = 30
const MINIMUM_SAVE_COST: int = 10
const MAXIMUM_SAVE_COST: int = 50

# Combat timing
const STUN_TIME: float = 0.5
const HURT_TIME: float = 0.3

# Player currency
var souls: int = 0
var gold: int = 0
var bank_gold: int = 0
var debt: int = 0

# Upgrade levels
var speed_level: int = 0
var strength_level: int = 0
var health_level: int = 0

# Current upgrade costs
var speed_cost: int = STARTING_UPGRADE_COST
var strength_cost: int = STARTING_UPGRADE_COST
var health_cost: int = STARTING_UPGRADE_COST


func save() -> void:
	var save_data = {
		"gold": gold,
		"bank_gold": bank_gold,
		"debt": debt,
		"speed_level": speed_level,
		"strength_level": strength_level,
		"health_level": health_level,
		"speed_cost": speed_cost,
		"strength_cost": strength_cost,
		"health_cost": health_cost
	}

	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(save_data)
	file.close()


func load_save() -> void:
	# There is nothing to load if the player has no save file.
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		return

	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	var save_data = file.get_var()
	file.close()

	gold = save_data["gold"]
	bank_gold = save_data["bank_gold"]
	debt = save_data["debt"]

	speed_level = save_data["speed_level"]
	strength_level = save_data["strength_level"]
	health_level = save_data["health_level"]

	speed_cost = save_data["speed_cost"]
	strength_cost = save_data["strength_cost"]
	health_cost = save_data["health_cost"]


func wipe_save() -> void:
	# Delete the save file if one exists.
	if FileAccess.file_exists(SAVE_FILE_PATH):
		DirAccess.remove_absolute(SAVE_FILE_PATH)

	# Reset the player's currency.
	souls = 0
	gold = 0
	bank_gold = 0
	debt = 0

	# Reset all upgrade levels.
	speed_level = 0
	strength_level = 0
	health_level = 0

	# Reset upgrade costs.
	speed_cost = STARTING_UPGRADE_COST
	strength_cost = STARTING_UPGRADE_COST
	health_cost = STARTING_UPGRADE_COST
