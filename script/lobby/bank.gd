extends Panel

@onready var gold_label = $VBoxContainer/Label2
@onready var bank_label = $VBoxContainer/Label3
@onready var debt_label = $VBoxContainer/Label4
@onready var deposit_amount = $VBoxContainer/SpinBox
@onready var withdraw_amount = $VBoxContainer/SpinBox2
@onready var deposit_btn = $VBoxContainer/Button
@onready var withdraw_btn = $VBoxContainer/Button2
@onready var loan_btn = $VBoxContainer/Button3

const LOAN_AMOUNT: int = 50
const DEBT_LIMIT: int = 200


func _ready() -> void:
	deposit_btn.pressed.connect(_on_deposit_pressed)
	withdraw_btn.pressed.connect(_on_withdraw_pressed)
	loan_btn.pressed.connect(_on_loan_pressed)
	update_ui()


func update_ui() -> void:
	gold_label.text = "Gold on hand: " + str(Global.gold)
	bank_label.text = "Gold in bank: " + str(Global.bank_gold)
	debt_label.text = "Current debt: " + str(Global.debt) + " gold"


func _on_deposit_pressed() -> void:
	var amount: int = int(deposit_amount.value)
	if Global.gold >= amount and amount > 0:
		Global.gold -= amount
		Global.bank_gold += amount
		update_ui()


func _on_withdraw_pressed() -> void:
	var amount: int = int(withdraw_amount.value)
	if Global.bank_gold >= amount and amount > 0:
		Global.bank_gold -= amount
		Global.gold += amount
		update_ui()


func _on_loan_pressed() -> void:
	Global.debt += LOAN_AMOUNT
	Global.gold += LOAN_AMOUNT
	update_ui()


func apply_floor_effects() -> void:
	# Apply 5% interest to bank savings
	if Global.bank_gold > 0:
		Global.bank_gold = int(Global.bank_gold * Global.INTEREST_RATE)

	# Apply 10% interest to debt
	if Global.debt > 0:
		Global.debt = int(Global.debt * Global.DEBT_RATE)

	# Auto deduct if debt exceeds limit
	if Global.debt > DEBT_LIMIT:
		var deduction: int = int(Global.debt * Global.DEBT_DEDUCTION)
		if Global.gold >= deduction:
			Global.gold -= deduction
		else:
			Global.bank_gold -= (deduction - Global.gold)
			Global.gold = 0
		Global.debt -= deduction
	update_ui()
