extends Node

func _ready():
	var d = 12.34
	var sp = StreamPeerBuffer.new()
	sp.put_double(d)
	# Representation:
	# binary: 40 28 AE 14 7A E1 47 AE
	# decimal: 1.2339999999999999857891452848E1
	# precision: double
	print(str_raw_array(sp.get_data_array()))
	sp.seek(0)	
	# Loss of precision when constructing double
	# https://github.com/godotengine/godot/blob/3.0/core/io/stream_peer.cpp#L313
	var d1 = sp.get_double() # In source code returning float, must return double
	print(d1)
	var sp1 = StreamPeerBuffer.new()
	sp1.put_double(d1)
	# Representation:
	# binary: 40 28 AE 14 80 00 00 00
	# decimal: 1.2340000152587890625E1
	# precision: single
	print(str_raw_array(sp1.get_data_array()))
	sp1.seek(0)
	var d2 = sp1.get_double()
	print(d2)
	var sp2 = StreamPeerBuffer.new()
	sp2.put_double(d2)
	print(str_raw_array(sp2.get_data_array()))
	sp2.seek(0)
	var d3 = sp2.get_double()
	print(d3)

# debug print

static func str_raw_array(arr):
	var res = "<<"
	for i in range(arr.size()):
		if i == (arr.size() - 1):
			res += str(arr[i]) + ">>"
		else:
			res += str(arr[i]) + ","
	return res

#func _ready():
#	create_json()
#	create_raw()
#	load_raw()


func create_json() -> void:
	var save_dict = {
		lemonade = {
			base_cost = 3.18236182e231,
			cost_factor = 1.000001e-12
		}
	}
	
	var save_file = File.new()
	save_file.open("res://config.json", File.WRITE)
	
	save_file.store_line(to_json(save_dict))
	save_file.close()
	
func create_raw() -> void:
	var save_file = File.new()
	save_file.open("res://config.dat", File.WRITE)
	
	#save_file.store_string("lemonade")
	save_file.store_double(3.18236182e231)
	save_file.store_double(1.000001e-12)
	save_file.close()

func load_raw() -> void:
	var save_file = File.new()
	save_file.open("res://config.dat", File.READ)
	
	#print(save_file.get_line())
	var f1 = save_file.get_double() 
	print(f1)
	print(f1 == 0.0)
	
	var f2 = save_file.get_double() 
	print(f2)
	print(f2 == 0.0)
	
	save_file.close()	


