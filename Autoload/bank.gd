extends Node

enum BuyMultiplier {BUY_1, BUY_10, BUY_100, BUY_UNDEF}

var balance: float = 0.0
var buy_multiplier: int = BuyMultiplier.BUY_1

func next_buy_multiplier() -> void:
	buy_multiplier += 1
	if buy_multiplier == BuyMultiplier.BUY_UNDEF:
		buy_multiplier = BuyMultiplier.BUY_1
	Signals.emit_signal("buy_multiplier_changed", buy_multiplier)


func add_to_balance(amount: float) -> void:
	balance += amount
	Signals.emit_signal("balance_changed", balance)
	
func withdraw(amount: float) -> bool:
	if balance >= amount:
		balance -= amount
		Signals.emit_signal("balance_changed", balance)
		return true
	else:
		return false
