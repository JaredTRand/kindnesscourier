extends CharacterBody3D

@export var npc_name: String = ""
@export var npc_pic:CompressedTexture2D
@export var animations:AnimationPlayer
@export var dialogue:DialogicTimeline 
@export var dialogue_char:DialogicCharacter
@export var dialogic_var_id:String
@export var acceptable_gift:Gift
@export var gift_to_give:Gift
@export var happiness_inc_val:int



@onready var interact_move_to:Vector3
@onready var interact_rotate_to:Vector3 
@onready var interact_dialogue:Sprite3D = %InteractDialogue


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
		
	var new_var_folderdata = 	{"acceptable_gift":acceptable_gift.gift_name,
								"first_interaction": false,
								"gift_from_player": false,
								"gift_to_player": false,
								"gift_to_give": gift_to_give.gift_name,
								"happiness_inc_val": happiness_inc_val
								}

	var fullstate = Dialogic.get_full_state()
	fullstate.variables[dialogic_var_id] = new_var_folderdata
	Dialogic.load_full_state(fullstate)
	
	dialogue_char.display_name = npc_name
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
