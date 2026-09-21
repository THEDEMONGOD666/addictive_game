extends CanvasLayer

@onready var souls_label = $soulslabel
@onready var gold_label = $goldlabel

func _process(delta):
	souls_label.text = "Souls: " + str(Global.souls)
	gold_label.text = "Gold: " + str(Global.gold)
