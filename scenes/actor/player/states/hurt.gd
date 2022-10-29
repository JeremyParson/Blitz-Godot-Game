extends "motion.gd"

#
export (float) var recovery_threshold
export (float) var flash_time = .5
export var FRICTION: float = .75

#
func initialize (args):
	velocity = Vector2(args[0], 0)

#
func enter (actor: Actor):
	# chatacter flash white
	owner.tween.interpolate_property(owner.material, "shader_param/flash_modifier", 0, 1, flash_time / 2)
	owner.tween.interpolate_property(owner.material, "shader_param/flash_modifier", 1, 0, flash_time / 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, .5)
	owner.animationPlayer.play("hurt")
	owner.tween.start()
	owner.set_aura(0)

#
func update (delta, actor: Actor):
	# Decrease velocity through interpolation
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	
	# Once velocity reaches the recovery_threshold return to idle state
	if velocity.length() < recovery_threshold:
		emit_signal("finished", "idle")
	
	velocity = owner.move_and_slide(velocity)
