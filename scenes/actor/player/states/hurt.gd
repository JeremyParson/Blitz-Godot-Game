extends "motion.gd"

export (float) var recovery_threshold = .01;
export (float) var flash_time = .5;
export var FRICTION: float = .75;

func initialize (args):
	velocity = Vector2(args[0], 0)

func enter (actor: Actor):
	actor.animationPlayer.play("hurt");

func update (delta, actor: Actor):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	
	if velocity.length() < recovery_threshold:
		emit_signal("finished", "idle", [velocity])
	
	velocity = owner.move_and_slide(velocity)
