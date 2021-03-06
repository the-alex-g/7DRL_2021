extends Area2D

# signals

# enums

# constants

# exported variables

# variables
var _ignore

# onready variables


func _ready()->void:
	_ignore = connect("body_entered", self, "_on_Area2D_body_entered")


func _on_Area2D_body_entered(body)->void:
	if body is Player:
		var bodies := get_overlapping_bodies()
		for body in bodies:
			if body is Enemy:
				body.active = true 
