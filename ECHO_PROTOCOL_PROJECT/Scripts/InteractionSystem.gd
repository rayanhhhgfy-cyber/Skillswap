extends RayCast3D

@onready var prompt_label = get_node_or_null("../../UI/HUD/InteractionPrompt")
@onready var inventory = get_node_or_null("../../Systems/Inventory")
@onready var dialogue_system = get_node_or_null("../../Systems/DialogueSystem")

func _process(delta):
	if is_colliding():
		var obj = get_collider()
		if obj.is_in_group("interactable"):
			if prompt_label:
				prompt_label.text = "[E] " + (obj.interaction_text if "interaction_text" in obj else "Interact")
				prompt_label.show()

			if Input.is_action_just_pressed("interact"):
				interact_with(obj)
		else:
			if prompt_label: prompt_label.hide()
	else:
		if prompt_label: prompt_label.hide()

func interact_with(obj):
	if obj.has_method("on_interact"):
		obj.on_interact()

	if obj.is_in_group("lore_log"):
		if inventory: inventory.add_lore_log(obj.log_id)
		if dialogue_system: dialogue_system.play_voice_log(obj.log_id)
		obj.queue_free()

	if obj.is_in_group("item"):
		if inventory: inventory.add_item(obj.item_id)
		obj.queue_free()

	if obj.is_in_group("door"):
		if obj.is_locked:
			if inventory and inventory.has_key(obj.key_id):
				obj.unlock()
			else:
				if prompt_label: prompt_label.text = "Locked."
		else:
			obj.toggle_door()
