extends MapSegment

# signals
signal crystals_changed(value)
signal won

# enums

# constants

# exported variables

# variables

# onready variables
onready var _sailer := $AnimationPlayer
onready var _boat := $Boat


func _ready()->void:
	_boat.position = Vector2(560,144)
	_boat.rotation_degrees = 0


func _on_crystals_changed(value:int)->void:
	emit_signal("crystals_changed", value)


func _on_Boat_depart():
	_sailer.play("Sail")


func _on_Area2D_body_entered(body):
	if body is Player:
		emit_signal("won")
