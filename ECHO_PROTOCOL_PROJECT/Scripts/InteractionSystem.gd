extends RayCast3D

@onready var prompt_label = get_node("/root/Game/UI/InteractionPrompt")
@onready var inventory = get_node("/root/Game/Systems/Inventory")
@onready var dialogue_system = get_node("/root/Game/Systems/DialogueSystem")

func _process(delta):
	if is_colliding():
		var obj = get_collider()
		if obj.is_in_group("interactable"):
			prompt_label.text = "[E] " + obj.interaction_text
			prompt_label.show()

			if Input.is_action_just_pressed("interact"):
				interact_with(obj)
		else:
			prompt_label.hide()
	else:
		prompt_label.hide()

func interact_with(obj):
	if obj.has_method("on_interact"):
		obj.on_interact()

	if obj.is_in_group("lore_log"):
		inventory.add_lore_log(obj.log_id)
		dialogue_system.play_voice_log(obj.log_id)
		obj.queue_free()

	if obj.is_in_group("item"):
		inventory.add_item(obj.item_id)
		obj.queue_free()

	if obj.is_in_group("door"):
		if obj.is_locked:
			if inventory.has_key(obj.key_id):
				obj.unlock()
			else:
				prompt_label.text = "Locked."
		else:
			obj.toggle_door()
