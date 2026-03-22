extends CharacterBody3D

@export var SPEED = 3.0
@export var SPRINT_SPEED = 5.0
@export var CROUCH_SPEED = 1.5
@export var JUMP_VELOCITY = 4.5
@export var MOUSE_SENSITIVITY = 0.05

@onready var camera = get_node_or_null("Camera3D")
@onready var mutation_manager = get_node_or_null("../MutationManager")

var is_crouching = false
var is_sprinting = false
var is_holding_breath = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion and camera:
		rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENSITIVITY))
		camera.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENSITIVITY))
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _physics_process(delta):
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
