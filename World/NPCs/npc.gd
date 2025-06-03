extends CharacterBody3D

@export var npc_name: String = ""
@export var npc_pic:CompressedTexture2D
@export var animations:AnimationPlayer
@export var dialogue:DialogicTimeline 
@export var dialogue_char:DialogicCharacter
@export var dialogic_var_id:String
@export var acceptable_gift:Gift
@export var gift_to_give:Gift


#@onready var pic_view:SubViewport = %pic_view
#@onready var pic_cam:Camera3D = %piccam
@onready var interact_move_to:Vector3
@onready var interact_rotate_to:Vector3 
@onready var interact_dialogue:Sprite3D = %InteractDialogue

#const my_scene: PackedScene = preload("res://World/interact_dialogue.tscn")
#@onready var is_interacting:bool = false

func _ready() -> void:
	add_to_group("npc")
	add_to_group("interactable")
	
	var anim : Animation= animations.get_animation("Idle")
	anim.loop_mode = Animation.LOOP_PINGPONG
	animations.play(anim.resource_name)
	#
	if %MoveToLocation: 
		interact_move_to = %MoveToLocation.get_global_position()
		interact_rotate_to = %MoveToLocation.get_global_rotation()
		
			#dialogicfolder.acceptable_gift = acceptable_gift.gift_name
			#dialogicfolder.gift_to_give = gift_to_give.gift_name
	var new_var_folderdata = 	{"acceptable_gift":acceptable_gift.gift_name,
								"first_interaction": false,
								"gift_from_player": false,
								"gift_to_player": false,
								"gift_to_give": gift_to_give.gift_name
								}
	#var new_dialogue_vars = Dialogic.VAR.VariableFolder.new(new_var_folderdata, dialogic_var_id, Dialogic.VAR)
	var fullstate = Dialogic.get_full_state()
	fullstate.variables[dialogic_var_id] = new_var_folderdata
	Dialogic.load_full_state(fullstate)
	
	#Dialogic.VAR.folders().append(new_dialogue_vars)
	dialogue_char.display_name = npc_name
	for dialogicfolder in Dialogic.VAR.folders():
		if dialogicfolder.path == dialogic_var_id:
			pass
	#dialogue_char.portraits["default"]  = npc_pic

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
