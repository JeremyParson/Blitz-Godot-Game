extends "motion.gd"

export var MAX_SPEED: float = 150.0
export var SPEED: float = 1500.0
export var FRICTION: float = 10
export var command_wait_time: float = .16
export var aura_recovery_rate: float = 4

# stores all the inputs that will be sent to the attack state
var command_inputs: Array

# determines how much time in between each input there is
var time: float = command_wait_time

func enter (actor: Actor):
	command_inputs.clear()
	time = 0


func update (delta, actor: Actor):
	# set character facing
	var facing = get_directional_input().x
	set_facing(facing)
	
	# set velocity and move the character
	velocity = velocity.clamped(MAX_SPEED)
	velocity = owner.move_and_slide(velocity)
	
	# increase aura recoveryv
	var aura_gained = aura_recovery_rate * delta
	owner.set_aura(owner.aura + aura_gained)
	
	# if command_wait_time runs out clear the command_inputs array
	time -= delta
	
	if time > 0: return
	
	if not command_inputs.size(): return
	
	# If the last command was an attack then enter the attack state
	if command_inputs.back() in ["Z", "X"]:
		emit_signal("finished", "attack")
	else:
		command_inputs.clear()

func handle_input (event: InputEvent, actor: Actor):
	time = command_wait_time
	
	if event is InputEventKey:
		if not event.pressed or event.is_echo():
			return
		
		var key = OS.get_scancode_string(event.scancode)
		
		# is the key presses is an attack key start the attack state
		if ("ZX").find(key) > -1:
			command_inputs.push_back(key)
		
		# if any directions are pressed in quick succession we record them
		elif key in ["Left", "Right", "Up", "Down"]:
			command_inputs.push_back(key[0])
