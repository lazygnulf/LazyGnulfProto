extends Control

signal new_balance(value)

var balance: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func add_to_balance(amount):
	balance += amount
	$BalanceDisplay.text = str(balance)
	emit_signal("new_balance", balance)
	
func withdraw(amount) -> bool:
	if balance >= amount:
		balance -= amount
		$BalanceDisplay.text = str(balance)
		emit_signal("new_balance", balance)
		return true
	else:
		return false


func _on_BankAccount_new_balance(value):
	pass # Replace with function body.
