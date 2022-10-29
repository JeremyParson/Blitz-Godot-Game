extends KinematicBody2D
class_name Actor

onready var tween: Tween = $Tween;
onready var stateMachine: StateMachine = $StateMachine;
onready var animationPlayer: AnimationPlayer = $AnimationPlayer;
onready var animateSprite: AnimatedSprite = $Pivot/AnimatedSprite;
onready var collision: CollisionShape2D = $CollisionShape2D;
onready var pivot: Position2D = $Pivot;

var _facing: int = -1;

func _ready():
	stateMachine.initialize();

func set_facing (direction: int):
	if direction and _facing != direction:
		_facing = direction;
		pivot.scale.x = direction;
