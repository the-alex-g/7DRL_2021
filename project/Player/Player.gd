class_name Player
extends KinematicBody2D

# signals
signal update_position(new_position)

# enums

# constants
const DETONATOR = preload("res://Player/Detonator.tscn")

# exported variables
export var _speed := 100

# variables
var _ignore
var _weapon_type := "staff"
var _clothes_type := "robe_blue"
var _damage_taken := 1
var _damage_dealt := 2
var _armor := 0
var _heal_delay := 1
var _cloak_bonuses := {}
var _staff_bonuses := {}
var _detonator_bonuses := {}

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
	
	if Input.is_action_just_pressed("launch_bomb"):
		var detonator = DETONATOR.instance()
		detonator.position = get_global_transform().origin
		get_parent().add_child(detonator)


func _get_animation(velocity:Vector2)->void:
	var anim_type := ""
	if velocity == Vector2.ZERO:
		anim_type = "idle_"
	else: anim_type = "walking_"
	_weapon.play(anim_type+_weapon_type)
	_clothes.play(anim_type+_clothes_type)


func take_damage(damage)->void:
	print("OW")


func is_player()->void:
	pass


func _on_item_equipped(item:Dictionary)->void:
	if item.hash() != {}.hash():
		var item_type:String = item["type"]
		var item_properties:Dictionary = item["properties"]
		match item_type:
			"cloak":
				for property in _cloak_bonuses:
					set(property, get(property)-_cloak_bonuses[property])
				for property in item_properties:
					set(property, get(property)+item_properties[property])
				_cloak_bonuses = item_properties
				_clothes_type = item["player_anim_type"]
			"staff":
				for property in _staff_bonuses:
					set(property, get(property)-_staff_bonuses[property])
				for property in item_properties:
					set(property, get(property)+item_properties[property])
				_staff_bonuses = item_properties
				_weapon_type = item["player_anim_type"]
			"detonator":
				for property in _detonator_bonuses:
					set(property, get(property)-_detonator_bonuses[property])
				for property in item_properties:
					set(property, get(property)+item_properties[property])
				_detonator_bonuses = item_properties
		print(_damage_dealt, " ", _damage_taken, " ", _armor, " ", _speed, " ", _heal_delay)
