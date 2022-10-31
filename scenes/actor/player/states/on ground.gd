extends "motion.gd"

export var MAX_SPEED: float = 150.0
export var SPEED: float = 1500.0
export var FRICTION: float = 10
export var command_wait_threshold: float = .14;
export var aura_recovery_rate: float = 4

var command_inputs: Array

var timer: float = command_wait_threshold;

func initialize (args: Array):
	if args.size() == 3:
		timer = args[1];
		command_inputs = args[2];
	.initialize(args);

func enter (actor: Actor):
	timer = 0;

func update (delta, actor: Actor):
	velocity = velocity.clamped(MAX_SPEED);
	if command_inputs.size():
		timer -= delta;
		if timer <= 0 and command_inputs.back() in ["LP", "LK", "HP", "HK"]:
			print(command_inputs)
			emit_signal("finished", "attack", [velocity, command_inputs.duplicate()]);
			command_inputs.clear()
			return;
		if timer <= 0:
			command_inputs.clear();
			timer = command_wait_threshold;
	.update(delta, actor);

func handle_input(event: InputEvent, actor: Actor):
	if not event is InputEventKey or not event.pressed or event.is_echo():
		return
	if event.is_action_pressed("game_light_punch", false):
		command_inputs.push_back("LP")
	elif event.is_action_pressed("game_light_kick", false):
		command_inputs.push_back("LK")
	elif event.is_action_pressed("game_heavy_punch", false):
		command_inputs.push_back("HP")
	elif event.is_action_pressed("game_heavy_kick", false):
		command_inputs.push_back("HK")

	if event.is_action_pressed("game_move_up"):
		command_inputs.push_back("U")
	elif event.is_action_pressed("game_move_down"):
		command_inputs.push_back("D")
	elif event.is_action_pressed("game_move_left"):
		command_inputs.push_back("L")
	elif event.is_action_pressed("game_move_right"):
		command_inputs.push_back("R")
	
	timer = command_wait_threshold;
