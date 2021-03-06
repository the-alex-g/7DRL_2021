extends Node2D

# signals
signal update_bridges
# enums

# constants

# exported variables

# variables
var _ignore

# onready variables


func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		emit_signal("update_bridges")

