extends CharacterBody3D

@export var npc_name: String = ""
@export var animations:AnimationPlayer
@export var dialogue:DialogicTimeline 

@onready var npc_pcam:PhantomCamera3D = %NPCPhantomCamera3D
@onready var interact_move_to:Vector3
@onready var interact_rotate_to:Vector3 
@onready var interact_dialogue:Sprite3D = %InteractDialogue

#const my_scene: PackedScene = preload("res://World/interact_dialogue.tscn")
#@onready var is_interacting:bool = false

func _ready() -> void:
	add_to_group("npc")
	
	var anim : Animation= animations.get_animation("Idle")
	anim.loop_mode = Animation.LOOP_PINGPONG
	animations.play(anim.resource_name)
	
	
	if %MoveToLocation: 
		interact_move_to = %MoveToLocation.get_global_position()
		interact_rotate_to = %MoveToLocation.get_global_rotation()
	#else:
		#var tempnode:Node3D = Node3D.new()
		#tempnode.translate_object_local(Vector3(0,0,2))
		#interact_move_to   = tempnode.get_global_position()
		#interact_rotate_to = tempnode.get_global_rotation()
		
	#if !interact_dialogue: 
		#interact_dialogue = my_scene.instantiate()

func do_colliding():
	interact_dialogue.show()
func stop_colliding():
	interact_dialogue.hide()

func do_interact():
		# check if a dialog is already running 
	if Dialogic.current_timeline != null || !dialogue:
		return
	
	#is_interacting = true
	Dialogic.start(dialogue)
	get_viewport().set_input_as_handled()
func stop_interact():
	pass
	#is_interacting = false
