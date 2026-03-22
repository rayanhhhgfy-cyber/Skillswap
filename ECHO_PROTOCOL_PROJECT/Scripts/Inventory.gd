extends Node

var lore_logs = []
var items = []

func add_lore_log(log_id):
	if not log_id in lore_logs:
		lore_logs.append(log_id)
		print("Lore Log Collected: ", log_id)

func add_item(item_id):
	items.append(item_id)
	print("Item Collected: ", item_id)

func has_item(item_id):
	return item_id in items

func get_total_logs():
	return lore_logs.size()

func has_key(key_id):
	return has_item(key_id)
