extends CanvasLayer

@onready var souls_label = $soulslabel
@onready var gold_label = $goldlabel


func _process(_delta: float) -> void:
	# Update HUD every frame with current values
	souls_label.text = "Souls: " + str(Global.souls)
	gold_label.text = "Gold: " + str(Global.gold)
