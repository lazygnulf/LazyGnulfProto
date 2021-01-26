class_name Business
extends Control

# ------------------------------------------------------------------------------
# Exported variables. 
# Key parameters/constants for the business when instantiated.
# TODO: document each variable
# TODO: to be read from config file sometime?
# ------------------------------------------------------------------------------
export (String) var business_name = "[Business Name]"
export (int) var initial_num_shops = 0
export (float) var base_cost = 0.0
export (float) var cost_factor = 0.0
export (int) var prod_time = 0
export (float) var revenue = 0.0
export (float) var auto_cost

var num_shops: int = 0
var in_production: bool = false
var production_progress: int = 0
var has_auto: bool = false

# Maximum number of shops that can be bought; updated every time the bank 
# balance is changed.
var max_affordable_shops: int = 0  

# timestamp in msecs of last production start
var timestamp_production_start: int = 0


# ------------------------------------------------------------------------------
# Variables for sub-nodes.
# Used to control the UI.
# ------------------------------------------------------------------------------
onready var name_label = $VBox/NameLabel
onready var shops_label = $VBox/HBox/NumShops
onready var shop_cost_label = $VBox/HBox2/ShopCost
onready var revenue_label = $VBox/HBox3/Revenue
onready var buy_shops_button = $VBox/HBox4/BuyShops
onready var buy_auto_button = $VBox/HBox4/BuyAuto
onready var produce_button = $VBox/Produce
onready var production_progressbar = $VBox/ProductionProgress
onready var production_progressbar_label = $VBox/ProductionProgress/Label


func _init() -> void:
	add_to_group("business")


func _ready() -> void:
	num_shops = initial_num_shops
	buy_auto_button.text = "Auto (" + str(auto_cost) + ")"
	buy_shops_button.connect("pressed", self, "on_buy_shops_pressed")
	buy_auto_button.connect("pressed", self, "on_buy_auto_pressed")
	produce_button.connect("pressed", self, "_on_Produce_pressed")
	Signals.connect("system_ticked", self, "_on_system_ticked")
	Signals.connect("buy_multiplier_changed", self, "_on_buy_multiplier_changed")
	Signals.connect("balance_changed", self, "_on_balance_changed")
	
	
	_update_ui()

	
# compute cost of next shops purchase according to current buy multiplier
func next_purchase_cost(num_shops_to_buy: int) -> float:
	if num_shops_to_buy == 0:
		return 0.0
	
	# cost of the next single shop
	var current_cost: float = base_cost * pow(cost_factor, num_shops)
		
	# compute cost using the geometric series formula
	return current_cost * (1.0-pow(cost_factor, num_shops_to_buy)) / (1.0-cost_factor)

# compute the maximum number of shops that can be bought
func compute_max_affordable_shops() -> int:
	var current_cost: float = base_cost * pow(cost_factor, num_shops)
	return int(log(1 - (Bank.balance*(1-cost_factor))/current_cost)/log(cost_factor))
	

func next_revenue() -> float:
	return num_shops * revenue


func _update_ui() -> void:
	name_label.text = business_name
	shops_label.text = str(num_shops)
	shop_cost_label.text = str(next_purchase_cost(_get_num_shops_next_purchase()))
	revenue_label.text = str(next_revenue())
	
	buy_shops_button.text = "Buy (x" + str(_get_num_shops_next_purchase()) + ")"
	buy_shops_button.disabled = _get_num_shops_next_purchase() == 0 || Bank.balance < next_purchase_cost(_get_num_shops_next_purchase())
	if !has_auto:
		buy_auto_button.disabled = num_shops == 0 || Bank.balance < auto_cost
	produce_button.disabled = num_shops == 0 || in_production
	production_progressbar.value = float(production_progress)*100 / prod_time
	production_progressbar_label.text = str(production_progress/1000) + " / " + str(prod_time/1000)
	$VBox/max.text = str(compute_max_affordable_shops())


func _get_num_shops_next_purchase() -> int:
	match Bank.buy_multiplier:
		Bank.BuyMultiplier.BUY_1:
			return 1
		Bank.BuyMultiplier.BUY_10:
			return 10
		Bank.BuyMultiplier.BUY_100:
			return 100
		Bank.BuyMultiplier.BUY_MAX:
			return max_affordable_shops
			
	return 1

func _on_system_ticked(delta: int) -> void:
	if in_production:
		production_progress += delta
		if production_progress > prod_time:
			Bank.add_to_balance(next_revenue())
			if !has_auto:
				in_production = false
			else:
				timestamp_production_start = OS.get_ticks_msec()
			production_progress = 0
		_update_ui()


func _on_balance_changed(new_balance: float) -> void:
	max_affordable_shops = compute_max_affordable_shops()
	_update_ui()	


func on_buy_shops_pressed() -> void:
	var num_shops_to_buy: int = _get_num_shops_next_purchase()
	if Bank.withdraw(next_purchase_cost(num_shops_to_buy)):
		num_shops += num_shops_to_buy
		_update_ui()
	
		
func on_buy_auto_pressed() -> void:
	if !has_auto && Bank.withdraw(auto_cost):
		buy_auto_button.visible = false
		has_auto = true
		in_production = true
		_update_ui()
	
	
func _on_Produce_pressed() -> void:
	timestamp_production_start = OS.get_ticks_msec()
	in_production = true
	_update_ui()
	
	
func _on_buy_multiplier_changed(buy_multiplier: int) -> void:
	_update_ui()
