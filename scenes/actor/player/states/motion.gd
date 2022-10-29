extends State

export var velocity: Vector2 = Vector2.ZERO

func initialize (args):
	velocity = args[0]

func set_facing (direction):
	if not direction: return
	if owner.facing != direction:
		owner.facing = direction
		owner.pivot.scale.x = direction

func get_directional_input ():
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var y_input = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return Vector2 (x_input, y_input)
