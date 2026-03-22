extends CharacterBody3D

enum Phase { PROFESSOR, ARCHITECT, FINAL_FORM }
var current_state = Phase.PROFESSOR

@export var health = 1500.0 # Total health
var phase_health_thresholds = [1000.0, 500.0, 0.0]

@export var speed = 4.0
@export var rotation_speed = 5.0

var player = null
@onready var mutation_manager = get_node_or_null("/root/Game/MutationManager") # Absolute path
@onready var dialogue_system = get_node_or_null("/root/Game/Systems/DialogueSystem") # Absolute path

# Phase 2 Specifics
var is_on_wall = false
var wall_target_pos = Vector3.ZERO

# Phase 3 Specifics
var infected_spawn_timer = 0.0
@export var spawn_interval = 15.0

func _ready():
    add_to_group("boss")
    player = get_node_or_null("/root/Game/Player")
    setup_phase_one()

func _physics_process(delta):
    if health <= 0:
        return

    match current_state:
        Phase.PROFESSOR:
            process_professor(delta)
        Phase.ARCHITECT:
            process_architect(delta)
        Phase.FINAL_FORM:
            process_final_form(delta)

    move_and_slide()

func take_damage(amount):
    health -= amount
    check_phase_transition()

func check_phase_transition():
    if current_state == Phase.PROFESSOR and health <= phase_health_thresholds[0]:
        transition_to_phase_two()
    elif current_state == Phase.ARCHITECT and health <= phase_health_thresholds[1]:
        transition_to_phase_three()

func transition_to_phase_two():
    current_state = Phase.ARCHITECT
    if dialogue_system: dialogue_system.play_dialogue("mahmoud_phase_two")
    setup_phase_two()

func transition_to_phase_three():
    current_state = Phase.FINAL_FORM
    if dialogue_system: dialogue_system.play_dialogue("mahmoud_phase_three")
    setup_phase_three()

# --- PHASE LOGIC ---

func setup_phase_one():
    print("Mahmoud: Phase 1 - The Professor.")

func process_professor(delta):
    if not player: return

    var dir = (player.global_position - global_position).normalized()
    dir.y = 0
    velocity = dir * speed

    var target_rotation = atan2(dir.x, dir.z)
    rotation.y = lerp_angle(rotation.y, target_rotation, rotation_speed * delta)

    if randf() < 0.01:
        print("Mahmoud triggers a chemical trap!")

func setup_phase_two():
    print("Mahmoud: Phase 2 - The Architect.")
    is_on_wall = true
    var tween = create_tween()
    tween.tween_property(self, "position:y", 6.0, 2.0)
    tween.tween_property(self, "rotation:z", PI/2, 1.0)

func process_architect(delta):
    if not player: return

    var target_pos = player.global_position
    target_pos.y = 6.0

    global_position = global_position.move_toward(target_pos, speed * 1.5 * delta)

    if randf() < 0.02:
        fire_bone_spur()

func fire_bone_spur():
    print("Mahmoud fires a bone-spur projectile!")

func setup_phase_three():
    print("Mahmoud: Phase 3 - Final Form.")
    var tween = create_tween()
    tween.set_parallel(true)
    tween.tween_property(self, "position:y", 0.0, 1.0)
    tween.tween_property(self, "rotation:z", 0.0, 1.0)
    tween.tween_property(self, "scale", Vector3(2, 2, 2), 2.0)

    if dialogue_system: dialogue_system.play_dialogue("mahmoud_phase_three")

func process_final_form(delta):
    velocity = Vector3.ZERO

    infected_spawn_timer += delta
    if infected_spawn_timer >= spawn_interval:
        spawn_infected_minions()
        infected_spawn_timer = 0.0

    if mutation_manager:
        mutation_manager.mutation_level += 0.1 * delta

func spawn_infected_minions():
    print("Mahmoud calls the horde!")

func handle_suppressor_injection():
    if health <= 50 and current_state == Phase.FINAL_FORM:
        var ending_manager = get_node_or_null("/root/Game/Systems/EndingManager")
        if ending_manager:
            ending_manager.trigger_boss_defeat()
