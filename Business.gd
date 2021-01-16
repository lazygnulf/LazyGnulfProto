extends Control

#signal new_income(value)

export (String) var business_name = "[Business Name]"
export (int) var initial_num_shops = 0
export (float) var base_cost = 0.0
export (float) var cost_factor = 0.0

export (float) var income = 0.0
export (float) var income_rate = 0.0 # in sec

onready var name_label = $VBox/NameLabel
onready var shops_label = $VBox/HBox/NumShops
onready var shop_cost_label = $VBox/HBox2/ShopCost
onready var buy_shops_button = $VBox/BuyShops

var num_shops: int = 0

# elapsed milliseconds since last income calculation
var msec_since_last_income: int = 0

# timestamp in msecs of last income calculation
var timestamp_last_income: int = 0


var account: Node = null


func _ready():
	num_shops = initial_num_shops
	buy_shops_button.connect("pressed", self, "_on_BuyShops_pressed")
	_update_ui()
	#var timer = get_shops_node().find_node("IncomeTimer")
	#timer.connect("timeout", self, "_on_timer_timeout")
	
func next_shop_cost() -> float:
	return base_cost * pow(cost_factor, num_shops)

func _update_ui() -> void:
	name_label.text = business_name
	shops_label.text = str(num_shops)
	shop_cost_label.text = str(next_shop_cost())

func set_account(acc):
	account = acc
	print(account.name)
	
func _on_timer_timeout():
	msec_since_last_income = OS.get_ticks_msec() - timestamp_last_income
	timestamp_last_income += msec_since_last_income
	account.add_to_balance(income)

	
	
func get_shops_node():
	#var root = get_node("/root")
	#print(root.name)
	#print(root.get_child(0).name)
	#return root.find_node("Shops")
	pass


func _on_BuyShops_pressed():
	num_shops += 1
	_update_ui()
