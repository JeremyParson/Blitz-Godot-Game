extends Node
class_name State

signal finished (state, arguments)

func initialize (args: Array):
	pass

func enter (actor: Actor):
	pass

func update (delta: float, actor: Actor):
	pass

func handle_input (event, actor: Actor):
	pass

# called when the state exits but is in the state stack
func sleep (actor: Actor):
	pass

# called when the state exits the state stack
func exit (actor: Actor):
	pass

func as_text () -> String:
	return ""
