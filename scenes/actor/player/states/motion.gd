extends State

export var velocity: Vector2 = Vector2.ZERO

func initialize (args):
	velocity = args[0]

func update (delta, actor):
	var facing = int(clamp(velocity.x, -1, 1));
	actor.set_facing(facing);
	velocity = actor.move_and_slide(velocity);

func get_directional_input ():
	var x_input = Input.get_action_strength("game_move_right") - Input.get_action_strength("game_move_left")
	var y_input = Input.get_action_strength("game_move_down") - Input.get_action_strength("game_move_up")
	return Vector2 (x_input, y_input)
