extends TextureRect

# signals
signal inventory_item_equipped(item, slot)
signal item_dropped(slot)

# enums

# constants

# exported variables
export var _inventory_slot := 1

# variables
var _ignore
var _item := {}
var _focused := false
var _label := ItemLabel.new()

# onready variables
onready var _item_image := $AnimatedSprite


func _process(_delta:float)->void:
	if _item.size() != 0:
		if _item["type"] != "crystal":
			if not _focused:
				return
			if Input.is_action_just_pressed("back"):
				_reset()
			if Input.is_action_just_pressed("equip"):
				_reset()
				emit_signal("inventory_item_equipped", _item, _inventory_slot)
			if Input.is_action_just_pressed("drop_item"):
				_reset()
				emit_signal("item_dropped", _inventory_slot)
				change_item({})


func _reset()->void:
	_label.queue_free()
	_label = ItemLabel.new()


func _on_InventoryItem_mouse_entered():
	if _item.size() != 0:
		if _item["type"] != "crystal":
			if _item.size() != 0:
				_label.generate_text(_item)
				get_parent().get_parent().add_child(_label)
				_focused = true


func _on_InventoryItem_mouse_exited():
	if _item.size() != 0:
		if _item["type"] != "crystal":
			_reset()
			_focused = false


func change_item(new_item:Dictionary)->void:
	_item = new_item
	var new_anim := ""
	if new_item.hash() != {}.hash():
		new_anim = _item["anim_name"]
	else: new_anim = "empty"
	_item_image.play(new_anim)
