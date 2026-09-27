extends Panel

var souls: int = 0
var gold: int = 0
var market_rate: float = 1.0

@onready var souls_label = $VBoxContainer/Label2
@onready var gold_label = $VBoxContainer/Label3
@onready var rate_label = $VBoxContainer/Label4
@onready var bracket_label = $VBoxContainer/Label5
@onready var input_field = $VBoxContainer/LineEdit
@onready var tax_label = $VBoxContainer/Label7
@onready var receive_label = $VBoxContainer/Label8
@onready var convert_btn = $VBoxContainer/Button


func _ready() -> void:
	convert_btn.pressed.connect(convert)
	input_field.text_changed.connect(update_preview)
	# Load current values from Global
	souls = Global.souls
	gold = Global.gold
	market_rate = randf_range(0.5, 1.5)
	input_field.text = str(souls)
	refresh()


func get_tax() -> int:
	# Return tax rate based on soul amount (income tax brackets)
	if souls < 100:
		return 10
	elif souls <= 300:
		return 20
	else:
		return 30


func refresh() -> void:
	souls_label.text = str(souls) + " souls"
	gold_label.text = str(gold) + " gold"
	rate_label.text = "1 soul = " + str(market_rate) + " gold"
	bracket_label.text = str(get_tax()) + "% tax"
	update_preview("")


func update_preview(new_text: String) -> void:
	var amount: int = int(input_field.text) if input_field.text.is_valid_int() else 0
	amount = clamp(amount, 0, souls)
	var gross: int = int(amount * market_rate)
	var tax: int = int(gross * get_tax() / 100.0)
	tax_label.text = "- " + str(tax) + " gold"
	receive_label.text = str(gross - tax) + " gold"


func convert() -> void:
	var amount: int = int(input_field.text) if input_field.text.is_valid_int() else 0
	amount = clamp(amount, 0, Global.souls)
	if amount <= 0:
		return
	var gross: int = int(amount * market_rate)
	var tax: int = int(gross * get_tax() / 100.0)
	# Update Global values after conversion
	Global.souls -= amount
	Global.gold += gross - tax
	souls = Global.souls
	gold = Global.gold
	refresh()
