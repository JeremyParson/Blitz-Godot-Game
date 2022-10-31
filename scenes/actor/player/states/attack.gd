extends 'motion.gd'

export var input_wait_time: float = .14;
export var FRICTION: float = .15;

var time: float = input_wait_time;
enum INPUT_STATE {
	INACTIVE,
	LISTENING,
}
var attack_input_state = INPUT_STATE.INACTIVE;
enum ATTACK_ANIMATION_STATES {
	IDLE,
	ACTIVE,
};

var attack_animation_state = ATTACK_ANIMATION_STATES.IDLE
var ready_for_next_attack := false

var command_inputs: Array = []

func initialize (args):
	command_inputs = args[1];
	.initialize(args);

func enter (actor: Actor):
	time = 0
	attack_input_state = INPUT_STATE.LISTENING
	ready_for_next_attack = true

func update (delta, actor: Actor):
	if attack_animation_state == ATTACK_ANIMATION_STATES.IDLE and not command_inputs.size():
		return emit_signal("finished", "idle", [velocity]);
	
	if attack_input_state == INPUT_STATE.LISTENING:
		time -= delta;
		if time > 0 or not command_inputs.size(): return;
		
		var attack: Dictionary;
		
		if MoveSetLibrary.is_move(command_inputs):
			attack = MoveSetLibrary.get_move(command_inputs)
		
		elif MoveSetLibrary.is_attack(command_inputs.back()):
			attack = MoveSetLibrary.get_attack_in_string(command_inputs.back())
		
		print(command_inputs)
		command_inputs.clear()
		
		if attack and ready_for_next_attack:
			ready_for_next_attack = false
			attack_input_state = INPUT_STATE.INACTIVE
			attack_animation_state = ATTACK_ANIMATION_STATES.ACTIVE
			actor.animationPlayer.stop();
			actor.animationPlayer.play(attack.animation);
	.update(delta, actor);

func handle_input (event, actor: Actor):
	if attack_input_state != INPUT_STATE.LISTENING:
		return
	if not event is InputEventKey or not event.pressed or event.is_echo():
		return
	if event.is_action_pressed("game_light_punch", false):
		command_inputs.push_back("LP")
	if event.is_action_pressed("game_light_kick", false):
		command_inputs.push_back("LK")
	if event.is_action_pressed("game_heavy_punch", false):
		command_inputs.push_back("HP")
	if event.is_action_pressed("game_heavy_kick", false):
		command_inputs.push_back("HK")

	if event.is_action_pressed("game_move_up"):
		command_inputs.push_back("U")
	if event.is_action_pressed("game_move_down"):
		command_inputs.push_back("D")
	if event.is_action_pressed("game_move_left"):
		command_inputs.push_back("L")
	if event.is_action_pressed("game_move_right"):
		command_inputs.push_back("R")
	
	time = input_wait_time

func set_attack_input_listening ():
	attack_input_state = INPUT_STATE.LISTENING
	time = input_wait_time

func set_ready_for_next_attack ():
	ready_for_next_attack = true

func animation_complete ():
	attack_animation_state = ATTACK_ANIMATION_STATES.IDLE
	if attack_input_state == INPUT_STATE.INACTIVE:
		emit_signal("finished", "idle")

func exit (actor: Actor):
	command_inputs.clear()
	attack_input_state = INPUT_STATE.INACTIVE
	MoveSetLibrary.reset_attack_string()

func set_x_speed (speed: int):
	if owner is Actor:
		var facing = owner.get_facing();
		velocity = Vector2(speed * facing, velocity.y);
