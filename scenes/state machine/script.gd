extends Node
class_name StateMachine

signal state_changed (current_state, previous_state)

export var START_STATE: NodePath
export(Array, String) var pushdown_states = []

onready var actor = get_parent()

onready var state_map = {}

var current_state;
var state_stack = []
var is_active = false

func _ready():
	for state in get_children():
		state.connect("finished", self, "_change_state")
	for child in get_children():
		var state_name = child.name.to_lower()
		state_map[state_name] = child

func initialize ():
	if not START_STATE: return
	var start_state = get_node(START_STATE)
	current_state = start_state
	state_stack = [current_state]
	is_active = true
	current_state.enter(actor)

func set_active (value):
	if value == is_active: return
	
	is_active = value
	set_process(value)
	
	if value:
		initialize()
	else:
		current_state.exit(actor)
		state_stack = []
		current_state = null

# returns the current state as text
func get_state_name () -> String:
	return current_state.as_text()

func _process(delta):
	if current_state:
		current_state.update(delta, actor)

func _change_state (state_name, args=[]):
	
	# don't change state if state machine if inactive
	if not is_active: return
	
	if state_name in pushdown_states:
		state_stack.push_front(null)
	
	if state_name == "previous":
		state_stack.pop_front()
	else:
		state_stack[0] = state_map[state_name]
	
	emit_signal("state_changed", state_stack[0], current_state)
	
	current_state.exit(actor)
	current_state = state_stack[0]
	if args.size(): state_stack[0].initialize(args)
	current_state.enter(actor)

func _input(event):
	if current_state:
		current_state.handle_input(event, actor)
