class_name Player
extends KinematicBody2D

# signals
signal update_position(new_position)

# enums

# constants

# exported variables
export var _speed := 100

# variables
var _ignore
var _weapon_type := "staff"
var _clothes_type := "blue_robes"

# onready variables
onready var _weapon := $Weapons
onready var _clothes := $Clothes


func _physics_process(delta)->void:
	var velocity := Vector2.ZERO
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if velocity != Vector2.ZERO:
		rotation = velocity.angle()
		velocity *= _speed*delta
		_ignore = move_and_collide(velocity)
		emit_signal("update_position", get_global_transform().origin)
	_get_animation(velocity)


func _get_animation(velocity:Vector2)->void:
	var anim_type := ""
	if velocity == Vector2.ZERO:
		anim_type = "idle_"
	else: anim_type = "walking_"
	_weapon.play(anim_type+_weapon_type)
	_clothes.play(anim_type+_clothes_type)
	
