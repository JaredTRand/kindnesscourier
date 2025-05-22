extends CharacterBody3D

@export var npc_name: String = ""

@onready var npc_pcam:PhantomCamera3D = %NPCPhantomCamera3D
@onready var interact_move_to:Vector3 = %MoveToLocation.get_global_position()
@onready var interact_rotate_to:Vector3 = %MoveToLocation.get_global_rotation()
@onready var interact_dialogue: Sprite3D = %InteractDialogue
#@onready var is_interacting:bool = false

func _ready() -> void:
	add_to_group("npc")

func do_colliding():
	interact_dialogue.show()
func stop_colliding():
	interact_dialogue.hide()

func do_interact():
		# check if a dialog is already running 
	if Dialogic.current_timeline != null:
		return
	
	#is_interacting = true
	Dialogic.start("res://World/NPCs/npc1/dialogue/timeline1.dtl")
	get_viewport().set_input_as_handled()
func stop_interact():
	pass
	#is_interacting = false
