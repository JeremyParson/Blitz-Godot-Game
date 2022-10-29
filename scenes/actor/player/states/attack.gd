extends 'motion.gd'

export var input_wait_time: float = .16;
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

var used_keys: Array = []

func initialize (args):
	used_keys = args[0]

func enter (actor: Actor):
	time = 0
	attack_input_state = INPUT_STATE.LISTENING
	ready_for_next_attack = true

func update (delta, actor: Actor):
	if attack_input_state != INPUT_STATE.LISTENING:
		return
	if attack_animation_state == ATTACK_ANIMATION_STATES.IDLE and not used_keys.size():
		emit_signal("finished", "idle", [velocity])
	time -= delta
	if time > 0 or not used_keys.size(): return
	
	var attack: Dictionary
	
	if ComboManager.is_move(used_keys):
		attack = ComboManager.get_move(used_keys)
	
	elif ComboManager.is_attack(used_keys.back()):
		attack = ComboManager.get_attack_in_string(used_keys.back())
	
	used_keys.clear()
	
	if attack and ready_for_next_attack:
		ready_for_next_attack = false
		attack_input_state = INPUT_STATE.INACTIVE
		attack_animation_state = ATTACK_ANIMATION_STATES.ACTIVE
		owner.animationPlayer.stop();
		owner.animationPlayer.play(attack.animation);
	.update(delta, actor);

func handle_input (event, actor: Actor):
	if attack_input_state != INPUT_STATE.LISTENING:
		return
	if not event is InputEventKey or not event.pressed or not event.is_echo():
		return
	
	var key = OS.get_scancode_string(event.scancode)

	if ("ZX").find(key) > -1:
		used_keys.append(key)
	
	elif key in ["Left", "Right", "Up", "Down"]:
		used_keys.append(key[0])
	
	# restart timer to allow for more input
	time = input_wait_time

# used by an animation player to determine when input should be enabled
func set_attack_input_listening ():
	attack_input_state = INPUT_STATE.LISTENING
	time = input_wait_time

# used by animation player to determine when the next action can be taken
func set_ready_for_next_attack ():
	ready_for_next_attack = true

func _on_Animation_finished(_animation):
	attack_animation_state = ATTACK_ANIMATION_STATES.IDLE
	if attack_input_state == INPUT_STATE.INACTIVE:
		emit_signal("finished", "idle")

func exit (actor: Actor):
	used_keys.clear()
	attack_input_state = INPUT_STATE.INACTIVE
	ComboManager.reset_attack_string()
