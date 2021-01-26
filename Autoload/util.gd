extends Node

func get_buy_multiplier_text() -> String:
	match Bank.buy_multiplier:
		Bank.BuyMultiplier.BUY_1:
			return "x1"
		Bank.BuyMultiplier.BUY_10:
			return "x10"			
		Bank.BuyMultiplier.BUY_100:
			return "x100"
		Bank.BuyMultiplier.BUY_MAX:
			return "Max"
	
	return "[ERROR]"	

