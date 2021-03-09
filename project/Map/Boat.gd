extends Node2D

# signals
signal depart

# enums

# constants

# exported variables

# variables
var _player:KinematicBody2D
var _ignore
var _can_sail := false
var _sailing := false

# onready variables
onready var _left_side := $Left/CollisionShape2D
onready var _right_side := $Right/CollisionShape2D
onready var _sprite := $AnimatedSprite
onready var _area := $Area2D/CollisionShape2D


func _process(_delta)->void:
	if not _sailing:
		return
	else:
		_player.position = get_global_transform().origin


func dock()->void:
	_left_side.set_deferred("disabled", true)
	_sailing = false


func depart()->void:
	_right_side.set_deferred("disabled", false)


func _on_Area2D_body_entered(body:Node2D)->void:
	if body is Player and _can_sail:
		print("sailed")
		_sailing = true
		_player = body
		emit_signal("depart")
		_area.set_deferred("disabled", true)


func _on_WinSegment_crystals_changed(value:int)->void:
	_sprite.play(str(value))
	if value == 3:
		_can_sail = true
		_area.set_deferred("disabled", false)
