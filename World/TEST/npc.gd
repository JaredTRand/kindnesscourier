extends CharacterBody3D

@export var npc_name: String = ""

@onready var npc_pcam:PhantomCamera3D = %NPCPhantomCamera3D
@onready var interact_move_to:Vector3 = %MoveToLocation.get_global_position()
@onready var interact_rotate_to:Vector3 = %MoveToLocation.get_global_rotation()
@onready var interact_dialogue: Sprite3D = %InteractDialogue
@onready var is_interacting:bool = false


func do_colliding():
	interact_dialogue.show()
func stop_colliding():
	interact_dialogue.hide()
