extends KinematicBody2D
class_name Actor

onready var tween: Tween = $Tween;
onready var stateMachine: StateMachine = $StateMachine;
onready var animationPlayer: AnimationPlayer = $AnimationPlayer;
onready var animateSprite: AnimatedSprite = $Pivot/AnimatedSprite;
onready var collision: CollisionShape2D = $CollisionShape2D;
onready var pivot: Position2D = $Pivot;
onready var particles: Particles2D = $Particles2D;

var _facing: int = -1 setget set_facing, get_facing;

func get_facing ():
	return _facing;

func set_facing (direction: int):
	if direction and _facing != direction:
		_facing = direction;
		pivot.scale.x = direction;

func _ready():
	stateMachine.initialize();

func hit (damage: int, knock_back: int, dir: Vector2):
	tween.stop_all();
	animateSprite.material.set("shader_param/flash_modifier", 0);
	var flash_time = .15;
	tween.interpolate_property(animateSprite.material, "shader_param/flash_modifier", 0, 1, flash_time / 2);
	tween.interpolate_property(animateSprite.material, "shader_param/flash_modifier", 1, 0, flash_time / 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, .5);
	tween.start();
	var facing = int(clamp(knock_back, -1, 1));
	set_facing(-facing);
	if not particles.emitting:
		particles.emitting = true
		particles.rotation = dir.angle() + deg2rad(-80);
	stateMachine._change_state("hurt", [knock_back]);

