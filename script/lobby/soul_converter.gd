extends Panel

var souls = 67
var gold = 0
var market_rate = 6

@onready var souls_label = $VBoxContainer/Label2
@onready var gold_label = $VBoxContainer/Label3
@onready var rate_label = $VBoxContainer/Label4
@onready var bracket_label = $VBoxContainer/Label5
@onready var input_field = $VBoxContainer/LineEdit
@onready var tax_label = $VBoxContainer/Label7
@onready var receive_label = $VBoxContainer/Label8
@onready var convert_btn = $VBoxContainer/Button

func _ready():
	convert_btn.pressed.connect(convert)
	input_field.text_changed.connect(update_preview)
	souls = Global.souls
	gold = Global.gold
	market_rate = randf_range(0.5, 1.5)
	input_field.text = str(souls)
	refresh()

func setup(s, g, rate):
	souls = s
	gold = g
	market_rate = rate
	input_field.text = str(souls)
	refresh()

func get_tax():
	if souls < 100:
		return 10
	elif souls <= 300:
		return 20
	else:
		return 30

func refresh():
	souls_label.text = str(souls) + " souls"
	gold_label.text = str(gold) + " gold"
	rate_label.text = "1 soul = " + str(market_rate) + " gold"
	bracket_label.text = str(get_tax()) + "% tax"
	update_preview("")

func update_preview(new_text):
	var amount = int(input_field.text) if input_field.text.is_valid_int() else 0
	amount = clamp(amount, 0, souls)
	var gross = int(amount * market_rate)
	var tax = int(gross * get_tax() / 100.0)
	tax_label.text = "- " + str(tax) + " gold"
	receive_label.text = str(gross - tax) + " gold"

func convert():
	var amount = int(input_field.text) if input_field.text.is_valid_int() else 0
	amount = clamp(amount, 0, Global.souls)
	if amount <= 0:
		return
	var gross = int(amount * market_rate)
	var tax = int(gross * get_tax() / 100.0)
	Global.souls -= amount
	Global.gold += gross - tax
	souls = Global.souls
	gold = Global.gold
	refresh()
