extends Control

onready var balanceDisplay = $Panel/BalanceDisplay

func _ready():
	Signals.connect("balance_changed", self, "_on_balance_changed")
	_update_ui()

func _update_ui() -> void:
	balanceDisplay.text = str(Util.float_to_string(Bank.balance, Util.NumberFormat.NAME))

func _on_balance_changed(new_balance: float) -> void:
	_update_ui()
