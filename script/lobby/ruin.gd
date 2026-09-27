extends Panel

@onready var gold_label = $VBoxContainer/Label2
@onready var speed_btn = $VBoxContainer/Button
@onready var strength_btn = $VBoxContainer/Button2
@onready var health_btn = $VBoxContainer/Button3
@onready var message_label = $VBoxContainer/Label3


func _ready() -> void:
	speed_btn.pressed.connect(upgrade_speed)
	strength_btn.pressed.connect(upgrade_strength)
	health_btn.pressed.connect(upgrade_health)
	message_label.hide()
	refresh()


func refresh() -> void:
	gold_label.text = "Gold: " + str(Global.gold)
	speed_btn.text = "Speed lv" + str(Global.speed_level) + " - " + str(Global.speed_cost) + " gold"
	strength_btn.text = "Strength lv" + str(Global.strength_level) + " - " + str(Global.strength_cost) + " gold"
	health_btn.text = "Max HP lv" + str(Global.health_level) + " - " + str(Global.health_cost) + " gold"

# To upgrade the user speed with gold if the  user gold is not = to the  ammount "the not enough gold"
func upgrade_speed() -> void:
	if Global.gold >= Global.speed_cost:
		Global.gold -= Global.speed_cost
		Global.speed_level += 1
		# Increase cost by 50% each upgrade
		Global.health_cost = int(Global.health_cost * Global.UPGRADE_COST_MULTIPLIER)
		message_label.text = "speed upgraded!"
		message_label.show()
		refresh()
	else:
		message_label.text = "not enough gold!"
		message_label.show()

# To upgrade the user strenght with gold if the  user gold is not = to the  ammount "the not enough gold"
func upgrade_strength() -> void:
	if Global.gold >= Global.strength_cost:
		Global.gold -= Global.strength_cost
		Global.strength_level += 1
		Global.health_cost = int(Global.health_cost * Global.UPGRADE_COST_MULTIPLIER)
		message_label.text = "strength upgraded!"
		message_label.show()
		refresh()
	else:
		message_label.text = "not enough gold!"
		message_label.show()

# To upgrade the user health with gold if the  user gold is not = to the  ammount "the not enough gold"
func upgrade_health() -> void:
	if Global.gold >= Global.health_cost:
		Global.gold -= Global.health_cost
		Global.health_level += 1
		Global.health_cost = int(Global.health_cost * Global.UPGRADE_COST_MULTIPLIER)
		message_label.text = "hp upgraded!"
		message_label.show()
		refresh()
	else:
		message_label.text = "not enough gold!"
		message_label.show()
