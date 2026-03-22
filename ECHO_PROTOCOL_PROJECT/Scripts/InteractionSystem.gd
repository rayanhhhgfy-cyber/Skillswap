extends RayCast3D

# Use absolute paths for UI and Systems to ensure reliability regardless of Player hierarchy depth
@onready var prompt_label = get_node_or_null("/root/Game/UI/HUD/InteractionPrompt")
@onready var inventory = get_node_or_null("/root/Game/Systems/Inventory")
@onready var dialogue_system = get_node_or_null("/root/Game/Systems/DialogueSystem")

func _process(_delta):
	var coll = get_collider()
	if is_colliding() and coll:
		if coll.is_in_group("interactable"):
			if prompt_label:
				var txt = coll.get("interaction_text")
				prompt_label.text = "[E] " + (txt if txt else "Interact")
				prompt_label.show()

			if Input.is_action_just_pressed("interact"):
				interact_with(coll)
		else:
			if prompt_label: prompt_label.hide()
	else:
		if prompt_label: prompt_label.hide()

func interact_with(obj):
	if obj.has_method("on_interact"):
		obj.on_interact()

	if obj.is_in_group("lore_log"):
		var id = obj.get("log_id")
		if id:
			if inventory: inventory.add_lore_log(id)
			if dialogue_system: dialogue_system.play_voice_log(id)
			obj.queue_free()

	if obj.is_in_group("item"):
		var item_id = obj.get("item_id")
		if item_id:
			if inventory: inventory.add_item(item_id)
			obj.queue_free()

	if obj.is_in_group("door"):
		if obj.get("is_locked"):
			var key_id = obj.get("key_id")
			if inventory and inventory.has_key(key_id):
				obj.call("unlock")
			else:
				if prompt_label: prompt_label.text = "Locked."
		else:
			obj.call("toggle_door")
