extends Control

export (String) var business_name = "[Business Name]"

onready var production_timer = $ProductionTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	var account = get_account()
	var shops = get_tree().get_nodes_in_group("shop")
	for shop in shops:
		production_timer.connect("timeout", shop, "_on_production_timer")
		shop.set_account(account)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_account():
	return get_node("/root/Game/HBoxContainer/BankAccount")

