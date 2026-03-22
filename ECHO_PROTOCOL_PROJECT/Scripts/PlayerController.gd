extends CharacterBody3D

@export var SPEED = 3.0
@export var SPRINT_SPEED = 5.0
@export var CROUCH_SPEED = 1.5
@export var JUMP_VELOCITY = 4.5
@export var MOUSE_SENSITIVITY = 0.05
@export var BOB_FREQ = 2.4
@export var BOB_AMP = 0.08

@onready var camera = get_node_or_null("Camera3D")
@onready var mutation_manager = get_node_or_null("../MutationManager")

@export var health = 100.0
var is_crouching = false
var is_sprinting = false
var is_holding_breath = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event_input):
	if event_input is InputEventMouseMotion and camera and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(deg_to_rad(-event_input.relative.x * MOUSE_SENSITIVITY))
		camera.rotate_x(deg_to_rad(-event_input.relative.y * MOUSE_SENSITIVITY))
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))

	if Input.is_action_just_pressed("ui_cancel"): # Escape key
		toggle_pause()

func toggle_pause():
	var pause_menu = get_node_or_null("/root/Game/UI/PauseMenu")
	if pause_menu:
		if pause_menu.visible:
			pause_menu.hide()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			get_tree().paused = false
		else:
			pause_menu.show()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			get_tree().paused = true

func _physics_process(delta):
	# Camera Bobbing
	var time = Time.get_ticks_msec() / 1000.0
	if camera and velocity.length() > 0.1:
		var bob = sin(time * BOB_FREQ) * BOB_AMP
		camera.position.y = 0.6 + bob
	elif camera:
		camera.position.y = move_toward(camera.position.y, 0.6, delta)

	# Apply visual mutation effects to hands (Example)
	if mutation_manager and camera:
		var _effect_level = mutation_manager.mutation_level / 100.0
		# Update shader uniforms here if a hand model exists

	# Movement logic
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	is_sprinting = Input.is_action_pressed("sprint")
	is_crouching = Input.is_action_pressed("crouch")

	var current_speed = SPEED
	if is_sprinting:
		current_speed = SPRINT_SPEED
	elif is_crouching:
		current_speed = CROUCH_SPEED

	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	# Breath-holding
	is_holding_breath = Input.is_action_pressed("hold_breath")

	move_and_slide()

func take_damage(amount):
	health -= amount
	print("Player hit! Health: ", health)
	# Visual feedback: Flash vignette
	var hud = get_node_or_null("/root/Game/UI/HUD")
	if hud: hud.show_damage_flash()

	if health <= 0:
		die()

func die():
	print("Player died.")
	get_tree().paused = true
	var pause_menu = get_node_or_null("/root/Game/UI/PauseMenu")
	if pause_menu:
		pause_menu.show()
		pause_menu.get_node("VBoxContainer/Title").text = "YOU DIED"
		pause_menu.get_node("VBoxContainer/ResumeButton").hide()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
