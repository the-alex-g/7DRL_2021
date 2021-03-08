class_name Player
extends KinematicBody2D

# signals
signal update_position(new_position)
signal update_powers(powers)
signal update_health(health)
signal dead

# enums

# constants
const DETONATOR = preload("res://Player/Detonator.tscn")

# exported variables
export var _speed := 100
export var _heal_delay := 3

# variables
var _ignore
var _weapon_type := "staff"
var _clothes_type := "robe_blue"
var _damage_taken := 1
var _damage_dealt := 2
var _max_health := 6
var _health := 6
var _armor := 0
var _cloak_bonuses := {}
var _staff_bonuses := {}
var _detonator_bonuses := {}
var _detonator_type := "blue"
var _dead := false
var _can_throw_bomb := true
var _cooldown_time := 1.6

# onready variables
onready var _weapon := $Weapons
onready var _clothes := $Clothes
onready var _heal_delay_timer := $HealDelayTimer
onready var _bomb_delay_timer := $BombTimer
onready var _hit_sound := $Hit


func _ready()->void:
	var power_dictionary := {"armor":_armor, "damage":_damage_dealt, "damage taken":_damage_taken}
	emit_signal("update_powers", power_dictionary)


func _physics_process(delta)->void:
	if not _dead:
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
			if _can_throw_bomb:
				var detonator = DETONATOR.instance()
				detonator.position = get_global_transform().origin
				detonator.type = _detonator_type
				detonator.damage = _damage_dealt
				take_damage(_damage_taken, false)
				get_parent().add_child(detonator)
				_can_throw_bomb = false
				_bomb_delay_timer.start(_cooldown_time)


func _get_animation(velocity:Vector2)->void:
	var anim_type := ""
	if velocity == Vector2.ZERO:
		anim_type = "idle_"
	else: anim_type = "walking_"
	_weapon.play(anim_type+_weapon_type)
	_clothes.play(anim_type+_clothes_type)


func take_damage(damage, armor_applies:bool = true)->void:
	if not _dead:
		_health -= (damage-_armor) if armor_applies else damage
		_heal_delay_timer.stop()
		if _health <= 0:
			_dead = true
			emit_signal("dead")
		else:
			emit_signal("update_health", _health)
			_heal_delay_timer.start(_heal_delay)
			if not armor_applies:
				_hit_sound.play()


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
				_detonator_type = item["player_anim_type"]
				_detonator_bonuses = item_properties
		var power_dictionary := {"armor":_armor, "damage":_damage_dealt, "damage taken":_damage_taken}
		emit_signal("update_powers", power_dictionary)


func _on_HealDelayTimer_timeout()->void:
	if not _dead:
		_health = _max_health
		emit_signal("update_health", _health)


func _on_BombTimer_timeout():
	_can_throw_bomb = true
