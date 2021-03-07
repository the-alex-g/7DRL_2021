extends GridContainer

# signals
signal equipped_item(item)

# enums

# constants

# exported variables

# variables
var _ignore
var _inventory_slots := {}

# onready variables
onready var _equipped_cloak := $Cloak
onready var _equipped_staff := $Staff
onready var _equipped_detonator := $Detonator


func _on_InventoryItem_inventory_item_equipped(item:Dictionary, slot:int):
	var item_type:String = item["type"]
	var inventory_slot = get_node("InventoryItem"+str(slot))
	var former_item:Dictionary
	match item_type:
		"cloak":
			former_item = _equipped_cloak.item
			_equipped_cloak.change_item(item)
		"staff":
			former_item = _equipped_staff.item
			_equipped_staff.change_item(item)
		"detonator":
			former_item = _equipped_detonator.item
			_equipped_detonator.change_item(item)
	emit_signal("equipped_item", item)
	inventory_slot.change_item(former_item)


func _on_HUD_item_picked_up(item):
	var item_type:String = item["type"]
	match item_type:
		"cloak":
			if _equipped_cloak.item.hash() == {}.hash():
				_equipped_cloak.change_item(item)
				emit_signal("equipped_item", item)
			elif _inventory_slots.size() < 3:
				var next_slot := _get_next_slot()
				var inventory_slot = get_node("InventoryItem"+str(next_slot))
				inventory_slot.change_item(item)
				_inventory_slots[next_slot] = item
		"staff":
			if _equipped_staff.item.hash() == {}.hash():
				_equipped_staff.change_item(item)
				emit_signal("equipped_item", item)
			elif _inventory_slots.size() < 3:
				var next_slot := _get_next_slot()
				var inventory_slot = get_node("InventoryItem"+str(next_slot))
				inventory_slot.change_item(item)
				_inventory_slots[next_slot] = item
		"detonator":
			if _equipped_detonator.item.hash() == {}.hash():
				_equipped_detonator.change_item(item)
				emit_signal("equipped_item", item)
			elif _inventory_slots.size() < 3:
				var next_slot := _get_next_slot()
				var inventory_slot = get_node("InventoryItem"+str(next_slot))
				inventory_slot.change_item(item)
				_inventory_slots[next_slot] = item


func _get_next_slot()->int:
	var next_slot := 4
	var all_slots := [1,2,3]
	for slot in _inventory_slots:
		if all_slots.has(slot):
			all_slots.erase(slot)
	for available_slot in all_slots:
		if available_slot < next_slot:
			next_slot = available_slot
	return next_slot


func _on_InventoryItem_item_dropped(item, slot):
	if _inventory_slots.has(slot):
		_inventory_slots.erase(slot)
