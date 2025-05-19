extends Node
var town_happiness: float = 0.0
var max_happiness: float = 0.0

var is_input_controller:bool = false

func _input(event: InputEvent) -> void:
	if event == InputEventKey or event == InputEventMouse or event == InputEventMouseButton:
		is_input_controller = false
	else:
		is_input_controller = true

func inc_happiness(factor:float):
	town_happiness += factor
