extends Panel

@onready var gold_label = $VBoxContainer/Label2
@onready var bank_label = $VBoxContainer/Label3
@onready var debt_label = $VBoxContainer/Label4
@onready var deposit_amount = $VBoxContainer/SpinBox
@onready var withdraw_amount = $VBoxContainer/SpinBox2
@onready var deposit_btn = $VBoxContainer/Button
@onready var withdraw_btn = $VBoxContainer/Button2
@onready var loan_btn = $VBoxContainer/Button3

var player_gold: int = 198
var bank_gold: int = 0
var player_debt: int = 0
const LOAN_AMOUNT = 50
const DEBT_LIMIT = 200
func _ready():
	deposit_btn.pressed.connect(_on_deposit_pressed)
	withdraw_btn.pressed.connect(_on_withdraw_pressed)
	loan_btn.pressed.connect(_on_loan_pressed)
	update_ui()

func update_ui():
	gold_label.text = "Gold on hand: " + str(player_gold)
	bank_label.text = "Gold in bank: " + str(bank_gold)
	debt_label.text = "Current debt: " + str(player_debt) + " gold"

func _on_deposit_pressed():
	var amount = int(deposit_amount.value)
	if player_gold >= amount and amount > 0:
		player_gold -= amount
		bank_gold += amount
		update_ui()

func _on_withdraw_pressed():
	var amount = int(withdraw_amount.value)
	if bank_gold >= amount and amount > 0:
		bank_gold -= amount
		player_gold += amount
		update_ui()

func _on_loan_pressed():
	player_debt += LOAN_AMOUNT
	player_gold += LOAN_AMOUNT
	update_ui()

func apply_floor_effects():
	if bank_gold > 0:
		bank_gold = int(bank_gold * 1.05)
 
	if player_debt > 0:
		player_debt = int(player_debt * 1.10)
   
	if player_debt > DEBT_LIMIT:
		var deduction = int(player_debt * 0.20)
		if player_gold >= deduction:
			player_gold -= deduction
		else:
			bank_gold -= (deduction - player_gold)
			player_gold = 0
		player_debt -= deduction
	update_ui()
