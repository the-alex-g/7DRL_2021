extends Enemy

# signals

# enums

# constants

# exported variables

# variables
var _leap_target:Vector2
var _leap_direction:Vector2
var _leap_velocity:Vector2

# onready variables
onready var _leap_range := $Area2D
onready var _leap_cooldown_timer := $Timer


func _ready()->void:
	_damage = 2
	_type = "bman"
	_health = 4


func _process(delta:float)->void:
	if _state == State.ACTIVE:
		var bodies_in_leap_range:Array = _leap_range.get_overlapping_bodies()
		for body in bodies_in_leap_range:
			if body is Player:
				_leap_at()
	elif _state == State.ATTACKING:
		var collision := move_and_collide(_leap_velocity*delta)
		if collision != null:
			if collision.collider is Player:
				collision.collider.take_damage(_damage)
				_state = State.PAUSED
				_leap_cooldown_timer.start()
		if (get_global_transform().origin-_leap_target).length_squared() < 250:
			_state = State.PAUSED
			_leap_cooldown_timer.start()


func _leap_at()->void:
	_state = State.ATTACKING
	_speed = 40
	_leap_target = _target_position
	_leap_direction = _leap_target-get_global_transform().origin
	rotation = _leap_direction.angle()
	_leap_velocity = _leap_direction.normalized()*_speed



func _on_Timer_timeout()->void:
	if _state != State.DEAD:
		_speed = 25
		_state = State.ACTIVE
