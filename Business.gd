extends Control

#signal new_income(value)

export (String) var business_name = "[Business Name]"
export (int) var initial_num_shops = 0
export (float) var base_cost = 0.0
export (float) var cost_factor = 0.0

# base production time in msec
export (int) var prod_time = 0

export (float) var revenue = 0.0

onready var name_label = $VBox/NameLabel
onready var shops_label = $VBox/HBox/NumShops
onready var shop_cost_label = $VBox/HBox2/ShopCost
onready var revenue_label = $VBox/HBox3/Revenue
onready var buy_shops_button = $VBox/BuyShops
onready var produce_button = $VBox/Produce
onready var production_progressbar = $VBox/ProductionProgress
onready var production_progressbar_label = $VBox/ProductionProgress/Label


var num_shops: int = 0
var in_production: bool = false
var production_progress: int = 0

# timestamp in msecs of last production start
var timestamp_production_start: int = 0


var account: Node = null


func _ready():
	num_shops = initial_num_shops
	buy_shops_button.connect("pressed", self, "_on_BuyShops_pressed")
	produce_button.connect("pressed", self, "_on_Produce_pressed")
	_update_ui()
	#var timer = get_shops_node().find_node("IncomeTimer")
	#timer.connect("timeout", self, "_on_timer_timeout")
	
func next_shop_cost() -> float:
	return base_cost * pow(cost_factor, num_shops)
	
func next_revenue() -> float:
	return num_shops * revenue

func _update_ui() -> void:
	name_label.text = business_name
	shops_label.text = str(num_shops)
	shop_cost_label.text = str(next_shop_cost())
	revenue_label.text = str(next_revenue())
	buy_shops_button.disabled = account == null ||  account.balance < next_shop_cost()
	produce_button.disabled = num_shops == 0 || in_production
	production_progressbar.value = float(production_progress)*100 / prod_time
	production_progressbar_label.text = str(production_progress/1000) + " / " + str(prod_time/1000)
	

func set_account(acc):
	account = acc
	account.connect("new_balance", self, "_on_new_balance")
	
func _on_production_timer():
	if in_production:
		production_progress = OS.get_ticks_msec() - timestamp_production_start
		if production_progress > prod_time:
			account.add_to_balance(next_revenue())
			in_production = false
			production_progress = 0
		_update_ui()

func _on_BuyShops_pressed():
	if account.withdraw(next_shop_cost()):
		num_shops += 1
		_update_ui()
	
func _on_Produce_pressed():
	timestamp_production_start = OS.get_ticks_msec()
	in_production = true
	_update_ui()
	
func _on_new_balance(value):
	_update_ui()
