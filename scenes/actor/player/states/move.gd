extends "on ground.gd"

func enter (actor: Actor):
	actor.animationPlayer.play("move");

func update (delta: float, actor: Actor):
	var input_vector = get_directional_input();
	
	if input_vector == Vector2.ZERO:
		emit_signal("finished", "idle", [velocity, timer, command_inputs]);
	
	var acceleration = input_vector * SPEED;
	velocity = velocity + (acceleration * delta);
	if input_vector.x == 0: velocity.x = lerp(velocity.x, 0, .1);
	if input_vector.y == 0: velocity.y = lerp(velocity.y, 0, .1);
	.update(delta, actor);
