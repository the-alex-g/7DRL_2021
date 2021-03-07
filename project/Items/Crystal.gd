extends Node2D

# signals
signal picked_up(item)

# enums

# constants

# exported variables

# variables
var _ignore
var _item := {"type":"crystal", "anim_name":"crystal"}
var _pickup := false

# onready variables
onready var _item_image := $AnimatedSprite


func _ready()->void:
	_item_image.play(_item["anim_name"])
	_ignore = connect("picked_up", get_parent(), "_on_item_picked_up")


func _process(_delta)->void:
	if not _pickup:
		return
	else:
		emit_signal("picked_up", _item)
		queue_free()


func _on_ItemDrop_body_entered(body)->void:
	if body is Player:
		_pickup = true


func _on_ItemDrop_body_exited(body)->void:
	if body is Player:
		_pickup = false
