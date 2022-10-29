extends "on ground.gd"

func enter (actor: Actor):
	actor.animationPlayer.play("idle")

func update (delta, actor: Actor):
	var input_vector = get_directional_input();
	if input_vector != Vector2.ZERO:
		emit_signal("finished", "move", [velocity]);
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION);
	.update(delta, actor);
