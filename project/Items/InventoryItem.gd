extends TextureRect

# signals
signal inventory_item_equipped(item, slot)

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
	if is_set_as_toplevel():
		if Input.is_action_just_pressed("back"):
			_reset()
		if Input.is_action_just_pressed("equip"):
			_reset()
			emit_signal("inventory_item_equipped", _item, _inventory_slot)
		if Input.is_action_just_pressed("remove"):
			_reset()
			change_item({})
	if not _focused:
		return
		
	if Input.is_action_just_pressed("select") and _item.hash() != {}.hash():
		set_as_toplevel(true)
		_label.generate_text(_item)
		add_child(_label)


func _reset()->void:
	_label.queue_free()
	_label = ItemLabel.new()
	set_as_toplevel(false)


func _on_InventoryItem_mouse_entered():
	_focused = true


func _on_InventoryItem_mouse_exited():
	_focused = false


func change_item(new_item:Dictionary)->void:
	_item = new_item
	var new_anim := ""
	if new_item.hash() != {}.hash():
		new_anim = _item["anim_name"]
	else: new_anim = "empty"
	_item_image.play(new_anim)