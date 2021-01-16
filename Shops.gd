extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var timer = get_node("IncomeTimer")
	var account = get_account()
	var shops = get_tree().get_nodes_in_group("shop")
	for shop in shops:
		timer.connect("timeout", shop, "_on_timer_timeout")
		shop.set_account(account)
		



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_account():
	return get_node("/root/Game/HBoxContainer/BankAccount")

