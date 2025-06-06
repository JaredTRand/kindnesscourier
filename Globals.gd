extends Node

@onready var all_npcs:Array = get_tree().get_nodes_in_group("npc")
var player:CharacterBody3D

var town_happiness: float = 0.0
var max_happiness: float = 0.0

var is_input_controller:bool = false
signal happiness_increased

@onready var GIFTS_LIST: Array

func _ready() -> void:
	#Load list of gifts on start
	for filePath in DirAccess.get_files_at("res://assets/gifts/allgifts/"):
		if filePath.get_extension() == "tres":  
			GIFTS_LIST.append( load("res://assets/gifts/allgifts/" + filePath) 
	)


func _input(event: InputEvent) -> void:
	if event == InputEventKey or event == InputEventMouse or event == InputEventMouseButton:
		is_input_controller = false
	else:
		is_input_controller = true

func inc_happiness(factor:float):
	town_happiness += factor
	happiness_increased.emit()

func player_has_gift(gift_to_check:String):
	for gift in player.INVENTORY:
		if gift.gift_name == gift_to_check:
			return true
	return false

func player_remove_gift(gift_to_check:String):
	for gift in player.INVENTORY:
		if gift.gift_name == gift_to_check:
			player.INVENTORY.remove_at( player.INVENTORY.find(gift) )
			print(gift_to_check + " removed from inventory")
	return false

func player_gain_gift(gift_to_gain:String):
	var gift_to_add: Resource
	for gift in GIFTS_LIST:
		if gift.gift_name == gift_to_gain:
			gift_to_add = gift
			break
	
	if gift_to_add: 
		player.INVENTORY.append(gift_to_add)
		print(gift_to_add.gift_name + " added to inventory")
