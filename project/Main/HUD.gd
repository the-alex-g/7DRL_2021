extends CanvasLayer

# signals
signal item_picked_up(item)

# enums

# constants

# exported variables

# variables
var _ignore

# onready variables


func _on_Main_item_picked_up(item):
	emit_signal("item_picked_up", item)
