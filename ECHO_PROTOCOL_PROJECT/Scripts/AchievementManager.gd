extends Node

# Extensive achievement and statistics tracking system
var statistics = {
	"kills": 0,
	"mutation_time": 0.0,
	"distance_traveled": 0.0,
	"items_collected": 0,
	"dialogues_heard": 0
}

var achievements = {
	"first_kill": {"unlocked": false, "name": "Self Defense", "desc": "Neutralize your first Infected."},
	"high_mutation": {"unlocked": false, "name": "Monster Within", "desc": "Reach 90% mutation for the first time."},
	"lore_master": {"unlocked": false, "name": "The Truth Hurts", "desc": "Find all 42 lore logs."}
}

func record_stat(id, value):
	if id in statistics:
		if value is float: statistics[id] += value
		else: statistics[id] += 1
		check_achievements()

func check_achievements():
	if statistics["kills"] >= 1 and not achievements["first_kill"].unlocked:
		unlock_achievement("first_kill")

func unlock_achievement(id):
	if id in achievements:
		achievements[id].unlocked = true
		print("ACHIEVEMENT UNLOCKED: ", achievements[id].name)
		# UI notification signal
