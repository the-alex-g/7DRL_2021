class_name Enemy
extends KinematicBody2D

# signals
signal dead

# enums
enum State {ACTIVE, DEAD, IDLE, ATTACKING, PAUSED}

# constants
const ITEM_DROP := "res://Items/ItemDrop.tscn"

# exported variables
export var _speed := 25
export var _type := ""
export var _damage := 2

# variables
var _ignore
var _state = State.IDLE
var _target_position := Vector2.ZERO
var active := false
var _health := 4

# onready variables
onready var _collision_shape := $CollisionShape2D
onready var _sprite := $AnimatedSprite

func _process(delta)->void:
	if _state == State.IDLE:
		_sprite.play(_type+"_idle")
		if active:
			_state = State.ACTIVE
		else: return
	elif _state == State.ACTIVE:
		_sprite.play(_type+"_walk")
		var direction := _target_position-get_global_transform().origin
		rotation = direction.angle()
		var velocity:Vector2 = direction.normalized()*_speed*delta
		_ignore = move_and_collide(velocity)
	elif _state == State.DEAD:
		_collision_shape.disabled = true
	elif _state == State.ATTACKING:
		_sprite.play(_type+"_attack")


func _on_update_player_position(new_position)->void:
	_target_position = new_position


func take_damage(damage)->void:
	if _state == State.ACTIVE or _state == State.ATTACKING or _state == State.PAUSED:
		_health -= damage
		if _health <= 0:
			_state = State.DEAD
			emit_signal("dead")
			_spawn_item()


func _spawn_item()->void:
	var should_spawn_item := (randi()%3) > 1
	if should_spawn_item:
		var item:Node2D = load(ITEM_DROP).instance()
		item.position = get_global_transform().origin
		get_parent().add_child(item)
