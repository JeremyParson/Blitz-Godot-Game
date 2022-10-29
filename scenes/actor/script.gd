extends KinematicBody2D
class_name Actor

onready var tween: Tween = $Tween;
onready var stateMachine: StateMachine = $StateMachine;
onready var animationPlayer: AnimationPlayer = $AnimationPlayer;
onready var animateSprite: AnimatedSprite = $AnimationPlayer;
onready var collision: CollisionShape2D = $CollisionShape2D;
onready var pivot: Position2D = $Pivot;

var _facing: int = -1;

func set_facing (direction: int):
	if _facing != direction:
		_facing = direction;
		scale.x = direction;
