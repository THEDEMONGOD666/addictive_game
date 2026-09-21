extends Node

var souls = 0
var gold = 0
var bank_gold = 0
var debt = 0
var speed_level = 0
var strength_level = 0
var health_level = 0
var speed_cost = 30
var strength_cost = 30
var health_cost = 30

const SAVE_PATH = "user://save.dat"

func save():
	var data = {
		"gold": gold,
		"bank_gold": bank_gold,
		"debt": debt,
		"speed_level": speed_level,
		"strength_level": strength_level,
		"health_level": health_level,
		"speed_cost": speed_cost,
		"strength_cost": strength_cost,
		"health_cost": health_cost,
	}
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(data)
	file.close()

func load_save():
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data = file.get_var()
	file.close()
	gold = data["gold"]
	bank_gold = data["bank_gold"]
	debt = data["debt"]
	speed_level = data["speed_level"]
	strength_level = data["strength_level"]
	health_level = data["health_level"]
	speed_cost = data["speed_cost"]
	strength_cost = data["strength_cost"]
	health_cost = data["health_cost"]

func wipe_save():
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
	souls = 0
	gold = 0
	bank_gold = 0
	debt = 0
	speed_level = 0
	strength_level = 0
	health_level = 0
	speed_cost = 30
	strength_cost = 30
	health_cost = 30
