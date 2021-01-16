extends Control

signal new_income(value)

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
