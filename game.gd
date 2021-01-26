class_name Game
extends Control

export (float) var simulation_speed = 1.0/50.0

var _timestamp_last_tick: int = OS.get_ticks_msec()

onready var system_timer = $SystemTimer


func _ready():
	system_timer.wait_time = simulation_speed
	system_timer.connect("timeout", self, "_on_system_ticked")

func _on_system_ticked() -> void:
	var now = OS.get_ticks_msec()
	Signals.emit_signal("system_ticked", now - _timestamp_last_tick)
	_timestamp_last_tick = now

