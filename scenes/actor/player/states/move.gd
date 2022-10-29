extends "on ground.gd"

func enter (actor: Actor):
	owner.animationPlayer.play("run");

func update (delta: float, actor: Actor):
	var input_vector = get_directional_input();
	
	if input_vector == Vector2.ZERO:
		emit_signal("finished", "idle");
	
	var acceleration = input_vector * SPEED;
	velocity = velocity + (acceleration * delta);
	
	.update(delta, actor);
