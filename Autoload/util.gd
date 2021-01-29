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
	
	
enum NumberFormat {NAME, NAME_SHORT, ENGINEERING}
	
var _num_names = {
	060: ["Nod", 	"Novemdecillion"],
	057: ["Ocd", 	"Octodecillion"],
	054: ["Spd",	"Septendecillion"],
	051: ["Sxd", 	"Sexdecillion"],
	048: ["Qid", 	"Quindecillion"],
	045: ["Qad", 	"Quattuordecillion"],
	042: ["Td", 	"Tredecillion"],
	039: ["Dd", 	"Duodecillion"],
	036: ["Ud", 	"Undecillion"],
	033: ["Dc", 	"Decillion"],
	030: ["No", 	"Nonillion"],
	027: ["Oc", 	"Octillion"],
	024: ["Sp", 	"Septillion"],
	021: ["Sx", 	"Sextillion"],
	018: ["Qi", 	"Quintillion"],
	015: ["Qa", 	"Quadrillion"],
	012: ["T", 		"Trillion"], 
	009: ["B", 		"Billion"],
	006: ["M", 		"Million"],
	003: ["K", 		"Thousand"]
}

func float_to_string(val: float, mode: int=NumberFormat.ENGINEERING) -> String:
	var e: int = 0
	while val > 1000.0:
		val /= 1000.0
		e += 3
	
	if e < 1:
		return "%7.2f" % val
	
	match mode:
		NumberFormat.NAME:
			return "%7.2f %s" % [val, _num_names[e][1]]
		NumberFormat.NAME_SHORT:
			return "%7.2f %s" % [val, _num_names[e][0]]

	return "%7.2fe%d" % [val, e]
