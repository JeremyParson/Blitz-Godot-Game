extends Area2D

export var _damage: int = 0 setget set_damage;
export var _knockback: int = 0 setget set_knockback;

func _ready():
	connect("area_entered", self, "_on_area_entered")

func set_damage (damage: int):
	_damage = damage;
	
func set_knockback (knockback: int):
	_knockback = knockback

func _on_area_entered (area: Area2D):
	if not owner is Actor: return;
	var target = area.owner;
	if target is Actor:
		var facing = owner.get_facing();
		var dir = owner.position.direction_to(target.position);
		target.hit(_damage, _knockback * facing, dir);
