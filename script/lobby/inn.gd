extends Panel

@onready var gold_label = $VBoxContainer/Label2
@onready var cost_label = $VBoxContainer/Label3
@onready var message_label = $VBoxContainer/Label4
@onready var save_btn = $VBoxContainer/Button

var cost: int = 0


func _ready() -> void:
	save_btn.pressed.connect(pay_and_save)
	message_label.hide()
	# Generate random save cost on open
	cost = randi_range(10, 50)
	gold_label.text = "Gold: " + str(Global.gold)
	cost_label.text = "Cost to save: " + str(cost) + " gold"


func pay_and_save() -> void:
	if Global.gold >= cost:
		Global.gold -= cost
		Global.save()
		get_tree().quit()
	else:
		message_label.text = "not enough gold!"
		message_label.show()
