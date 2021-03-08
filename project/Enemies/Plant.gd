extends Enemy

# signals

# enums

# constants

# exported variables

# variables

# onready variables
onready var _hit_cooldown := $HitCooldownTimer
onready var _anim_cooldown := $AnimTimer


func _ready()->void:
	_health = 8
	_drop_frequency = 2
	_damage = 3
	_speed = 5


func _on_HitArea_body_entered(body:Node)->void:
	if _state == State.ACTIVE:
		if body is Player:
			body.take_damage(_damage)
			_state = State.ATTACKING
			_hit_cooldown.start()
			_anim_cooldown.start()


func _on_HitCooldownTimer_timeout():
	if _state != State.DEAD:
		_state = State.ACTIVE


func _on_AnimTimer_timeout():
	if _state != State.DEAD:
		_state = State.PAUSED
