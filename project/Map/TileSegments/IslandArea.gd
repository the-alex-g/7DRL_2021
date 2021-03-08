extends Area2D

# signals
signal area_cleared
signal fight_started

# enums

# constants

# exported variables

# variables
var _ignore
var _enemies := -1

# onready variables


func _ready()->void:
	_ignore = connect("body_entered", self, "_on_Area2D_body_entered")
	_ignore = connect("area_cleared", Jukebox, "_on_area_cleared")
	_ignore = connect("fight_started", Jukebox, "_on_fight_started")


func _on_Area2D_body_entered(body)->void:
	if body is Player:
		var bodies := get_overlapping_bodies()
		if _enemies == -1:
			_enemies = 0
			for body in bodies:
				if body is Enemy:
					body.active = true
					_enemies += 1
					_ignore = body.connect("dead", self, "_on_area_enemy_dead")
			emit_signal("fight_started")


func _on_area_enemy_dead()->void:
	_enemies -= 1
	if _enemies == 0:
		_enemies = -1
		emit_signal("area_cleared")
