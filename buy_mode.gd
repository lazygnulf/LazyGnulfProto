extends PanelContainer

onready var buy_mult_button = $BuyMultiplierButton

# Called when the node enters the scene tree for the first time.
func _ready():
	buy_mult_button.connect("pressed", self, "_on_buy_mult_button_pressed")
	_update_ui()
	
func _update_ui() -> void:
	buy_mult_button.text = Util.get_buy_multiplier_text()

func _on_buy_mult_button_pressed() -> void:
	Bank.next_buy_multiplier()
	_update_ui()
