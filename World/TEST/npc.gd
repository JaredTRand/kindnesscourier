extends CharacterBody3D

@export var npc_name: String = ""
@export var interact_move_to: Node3D
@onready var interact_dialogue: Label3D = %InteractDialogue

func do_colliding():
	interact_dialogue.show()
func stop_colliding():
	interact_dialogue.hide()
