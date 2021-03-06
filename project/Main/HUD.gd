extends CanvasLayer

# signals
signal item_picked_up(item)
signal item_equipped(item)

# enums

# constants

# exported variables

# variables
var _ignore

# onready variables


func _on_Main_item_picked_up(item):
	emit_signal("item_picked_up", item)


func _on_GridContainer_equipped_item(item):
	emit_signal("item_equipped", item)
