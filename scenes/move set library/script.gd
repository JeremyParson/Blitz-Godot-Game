extends Node

var attack_string_name: String
var current_attack_index: int = 0

var moveset = {
	["Z", "X"]: {"animation": "attack3"},
	["L", "L", "Z"]: {"animation": "dash"},
	["R", "R", "Z"]: {"animation": "dash"},
	["U", "D", "X",]: {"animation": "blade rush"},
}

#
var attack_strings = {
	"LP": [{"animation": "punchA"}, {"animation": "punchB"}],
	"LK": [{"animation": "kick"}]
}

func get_attack_in_string(command):
	if attack_string_name != command:
		attack_string_name = command;
		current_attack_index = 0;
	var attack_string = attack_strings[attack_string_name];
	var _max = attack_string.size()
	
	current_attack_index = wrapi(current_attack_index + 1, 0, _max)
	print(current_attack_index);
	return attack_string[current_attack_index - 1]

func is_attack (command):
	return attack_strings.has(command)

func get_move (commands):
	return moveset[commands]

func is_move (commands):
	return moveset.has(commands)

func reset_attack_string ():
	attack_string_name = ""
	current_attack_index = 0
