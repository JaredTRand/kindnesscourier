extends "player_controller_4.4.gd"
class_name PhantomPlayer

## How fast the player moves on the ground.
@export var base_speed := 6.0
## How high the player can jump in meters.
@export var jump_height := 1.2
## How fast the player falls after reaching max jump height.
@export var fall_multiplier := 2.5

@export_category("Camera")
@export var mouse_sensitivity: float = 0.05

@export var min_pitch: float = -89.9
@export var max_pitch: float = 50

@export var min_yaw: float = 0
@export var max_yaw: float = 360

@export var min_zoom: float = 1.5
@export var max_zoom: float = 6.0
@export var zoom_sensitivity: float = 0.4



@onready var animation_tree: AnimationTree = $AnimationTree
@onready var run_particles: GPUParticles3D = $BasePivot/RunParticles
@onready var jump_particles: GPUParticles3D = $BasePivot/JumpParticles

@onready var jump_audio: AudioStreamPlayer3D = %JumpAudio
@onready var run_audio: AudioStreamPlayer3D = %RunAudio

@onready var _player_pcam: PhantomCamera3D

func _ready() -> void:
	super()
	_player_pcam = owner.get_node("%PlayerPhantomCamera3D")

	if _player_pcam.get_follow_mode() == _player_pcam.FollowMode.THIRD_PERSON:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	# Whenever the player loads in, give the autoload ui a reference to itself.
	UserInterface.update_player(self)




func _physics_process(delta: float) -> void:
	super(delta)

	# if velocity.length() > 0.2:
		# var look_direction: Vector2 = Vector2(velocity.z, velocity.x)
		# _player_direction.rotation.y = look_direction.angle()

	# Add gravity.
	if not is_on_floor():
		# if holding jump and ascending be floaty.
		if velocity.y >= 0 and Input.is_action_pressed("ui_accept"):
			velocity.y -= gravity * delta
		else:
			# Double fall speed, after peak of jump or release of jump button.
			velocity.y -= gravity * delta * fall_multiplier
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		# Projectile motion to turn jump height into a velocity.
		velocity.y = sqrt(jump_height * 2.0 * gravity)
		jump_particles.restart()
		jump_audio.play()
		run_audio.play()
	
	# Handle movement.
	var direction = get_movement_direction()
	if direction:
		velocity.x = lerp(velocity.x, direction.x * base_speed, base_speed * delta)
		velocity.z =  lerp(velocity.z, direction.z * base_speed, base_speed * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, base_speed * delta * 5.0)
		velocity.z = move_toward(velocity.z, 0, base_speed * delta * 5.0)
	
	# Emit run particles when moving on the floor.
	run_particles.emitting = not direction.is_zero_approx() and is_on_floor()
		
	update_animation_tree()
	move_and_slide()

# Turn movent inputs into a locally oriented vector.
func get_movement_direction() -> Vector3:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	return (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	

# Blend the walking animation based on movement direction.
func update_animation_tree() -> void:
	# Get the local movement direction.
	var movement_direction = basis.inverse() * velocity / base_speed
	# Convert the direction to a Vector2 to select the correct movement animation.
	var animation_target = Vector2(movement_direction.x, -movement_direction.z)
	animation_tree.set("parameters/blend_position", animation_target)

func _unhandled_input(event: InputEvent) -> void:
	if _player_pcam.get_follow_mode() == _player_pcam.FollowMode.THIRD_PERSON:

		_set_pcam_rotation(_player_pcam, event)

	# Capture the mouse if it is uncaptured.
	if event.is_action_pressed("click"):
		if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
	# Camera controls.
	#if event.is_action_pressed("toggle_view"):
		#cycle_view()
	if event.is_action_pressed("zoom_in"):
		pass
		#zoom -= zoom_sensitivity
	elif event.is_action_pressed("zoom_out"):
		pass
		#zoom += zoom_sensitivity
	
func _set_pcam_rotation(pcam: PhantomCamera3D, event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var pcam_rotation_degrees: Vector3

		# Assigns the current 3D rotation of the SpringArm3D node - so it starts off where it is in the editor
		pcam_rotation_degrees = pcam.get_third_person_rotation_degrees()

		# Change the X rotation
		pcam_rotation_degrees.x -= event.relative.y * mouse_sensitivity

		# Clamp the rotation in the X axis so it go over or under the target
		pcam_rotation_degrees.x = clampf(pcam_rotation_degrees.x, min_pitch, max_pitch)

		# Change the Y rotation value
		pcam_rotation_degrees.y -= event.relative.x * mouse_sensitivity

		# Sets the rotation to fully loop around its target, but witout going below or exceeding 0 and 360 degrees respectively
		pcam_rotation_degrees.y = wrapf(pcam_rotation_degrees.y, min_yaw, max_yaw)

		# Change the SpringArm3D node's rotation and rotate around its target
		pcam.set_third_person_rotation_degrees(pcam_rotation_degrees)


# Play a footstep sound effect when moving.
func _on_footstep_timer_timeout() -> void:
	if is_on_floor() and get_movement_direction():
		run_audio.play()
