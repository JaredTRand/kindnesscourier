extends CharacterBody3D

@export var npc_name: String = ""
@export var npc_pic:CompressedTexture2D
@export var animations:AnimationPlayer
@export var dialogue:DialogicTimeline 
@export var dialogue_char:DialogicCharacter


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
		#pic_cam.global_position = %MoveToLocation.get_global_position()
		#pic_cam.global_rotation = %MoveToLocation.get_global_rotation()
		#pic_cam.position = Vector3(pic_cam.position.x, pic_cam.position.y+2, pic_cam.position.z+2)
		#pic_cam.rotate_y(-90)
		
	#else:
		#var tempnode:Node3D = Node3D.new()
		#tempnode.translate_object_local(Vector3(0,0,2))
		#interact_move_to   = tempnode.get_global_position()
		#interact_rotate_to = tempnode.get_global_rotation()
		
	#if !interact_dialogue: 
		#interact_dialogue = my_scene.instantiate()
	dialogue_char.display_name = npc_name

func do_colliding():
	interact_dialogue.show()
func stop_colliding():
	interact_dialogue.hide()

func do_interact():
		# check if a dialog is already running 
	var filename = "res://World/NPCs/assets/profpics/npcpic-" + npc_name + ".png"
	
	#pic_view.render_target_update_mode = SubViewport.UPDATE_ONCE
	#await RenderingServer.frame_post_draw
	##
	#pic_view.get_texture().get_image().save_png(filename)
	#dialogue_char.portraits["neutral"]  = filename
	
	if Dialogic.current_timeline != null || !dialogue:
		return
	
	#is_interacting = true
	Dialogic.start(dialogue)
	get_viewport().set_input_as_handled()
func stop_interact():
	pass
	#is_interacting = false
