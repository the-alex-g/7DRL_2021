class_name Detonator
extends RigidBody2D

# signals

# enums

# constants

# exported variables

# variables
var _ignore
var _target_position := Vector2.ZERO
var damage := 2

# onready variables
onready var _tween := $Tween
onready var _timer := $Timer
onready var _damage_area := $DamageArea
onready var _bombrange := $Sprite


func _ready()->void:
	set_friction(1)
	_target_position = get_global_mouse_position()
	var velocity := (get_global_transform().origin-_target_position).normalized()*50
	velocity = velocity.rotated(PI)
	apply_impulse(Vector2.ZERO, velocity)


func _process(_delta)->void:
	if (get_global_transform().origin-_target_position).length_squared() < 10:
		sleeping = true


func _on_Timer_timeout()->void:
	if not _bombrange.visible:
		_bombrange.visible = true
		_timer.start(0.5)
	else:
		for body in _damage_area.get_overlapping_bodies():
			if body is Enemy or body.has_method("is_player"):
				body.take_damage(damage)
		queue_free()
