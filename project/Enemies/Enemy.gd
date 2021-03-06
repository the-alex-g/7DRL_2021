class_name Enemy
extends KinematicBody2D

# signals
signal dead

# enums
enum State {ACTIVE, DEAD, IDLE}

# constants

# exported variables
export var speed = 100

# variables
var _ignore
var _state = State.IDLE
var _target_position := Vector2.ZERO
var active := false

# onready variables

func _process(delta)->void:
	if _state == State.IDLE:
		if active:
			_state = State.ACTIVE
		else: return
	elif _state == State.ACTIVE:
		var direction := _target_position-get_global_transform().origin
		rotation = direction.angle()
		var velocity:Vector2 = direction.normalized()*speed*delta
		_ignore = move_and_collide(velocity)


func _on_update_player_position(new_position)->void:
	_target_position = new_position


func take_damage(damage):
	if _state == State.ACTIVE:
		emit_signal("dead")
		queue_free()
