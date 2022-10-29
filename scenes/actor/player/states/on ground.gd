extends "motion.gd"

export var MAX_SPEED: float = 150.0
export var SPEED: float = 1500.0
export var FRICTION: float = 10
export var command_wait_time: float = .16
export var aura_recovery_rate: float = 4

var command_inputs: Array

var time: float = command_wait_time

func enter (actor: Actor):
	command_inputs.clear()
	time = 0

func update (delta, actor: Actor):
	velocity = velocity.clamped(MAX_SPEED);
	time -= delta;
	if time < 0 and command_inputs.size():
		if command_inputs.back() in ["Z", "X"]:
			return emit_signal("finished", "attack", [command_inputs]);
		command_inputs.clear();
	
	.update(delta, actor);

func handle_input (event: InputEvent, actor: Actor):
	time = command_wait_time
	
	if event is InputEventKey:
		if not event.pressed or event.is_echo():
			return
		
		var key = OS.get_scancode_string(event.scancode)
		
		if ("ZX").find(key) > -1:
			command_inputs.push_back(key)

		elif key in ["Left", "Right", "Up", "Down"]:
			command_inputs.push_back(key[0])
