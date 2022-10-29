extends Node

var current_attack_string: String
var current_attack_index: int = 0

var moveset = {
	["Z", "X"]: {"animation": "attack3", "cost": 0},
	["L", "L", "Z"]: {"animation": "dash", "cost": 2},
	["R", "R", "Z"]: {"animation": "dash", "cost": 2},
	["U", "D", "X",]: {"animation": "blade rush", "cost": 5},
}

#
var attack_strings = {
	"X": [{"animation": "attack1"}, {"animation": "attack2"}],
	"Z": [{"animation": "attack1"}, {"animation": "attack2"}, {"animation": "attack3"}]
}

func get_attack_in_string(command):
	if current_attack_string != command:
		current_attack_string = command
		current_attack_index = 0
	
	var _max = attack_strings[current_attack_string].size()
	
	current_attack_index = wrapi(current_attack_index + 1, 0, _max)
	
	return attack_strings[current_attack_string][current_attack_index - 1]

func is_attack (command):
	return attack_strings.has(command)

func get_move (commands):
	return moveset[commands]

func is_move (commands):
	return moveset.has(commands)

func reset_attack_string ():
	current_attack_string = ""
	current_attack_index = 0
