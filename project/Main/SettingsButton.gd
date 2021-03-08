extends Button

# signals
signal change_input(action)

# enums

# constants

# exported variables
export var _action_type := ""

# variables
var _ignore

# onready variables


func _ready():
	_ignore = connect("pressed", self, "_on_Change_pressed")


func _on_Change_pressed():
	emit_signal("change_input", _action_type)
