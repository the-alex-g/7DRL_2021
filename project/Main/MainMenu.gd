extends Control

# signals

# enums
enum InputChange {ATTACK, PICKUP, DISCARD, DISCARD_INVENTORY, EQUIP, INVENTORY, INTERACT, NONE}

# constants

# exported variables

# variables
var _ignore
var _input_change = InputChange.NONE
var _arrow_keys := false

# onready variables
onready var _main_menu := $VBoxContainer
onready var _settings := $Settings


func _ready()->void:
	_settings.hide()
	_main_menu.show()
	_arrow_keys = OS.get_scancode_string(InputMap.get_action_list("left")[0].scancode) == "Left"
	$Settings/Movement.text = "Movement-Arrow Keys" if _arrow_keys else "Movement-WASD"
	$Settings/Attack.text = "Attack-"+_get_key(InputMap.get_action_list("launch_bomb"))
	$Settings/Pickup.text = "Pickup Item-"+_get_key(InputMap.get_action_list("pickup"))
	$Settings/Discard.text = "Discard Item-"+_get_key(InputMap.get_action_list("remove"))
	$Settings/Equip.text = "Equip Item-"+_get_key(InputMap.get_action_list("equip"))
	$Settings/Inventory.text = "Show Inventory-"+_get_key(InputMap.get_action_list("inventory"))
	$Settings/Interact.text = "Interact-"+_get_key(InputMap.get_action_list("interact"))
	$Settings/DiscardInventory.text = "Discard Inventory Item-"+_get_key(InputMap.get_action_list("drop_item"))


func _input(event:InputEvent)->void:
	if _input_change == InputChange.NONE:
		return
	if event is InputEventKey or event is InputEventMouseButton:
		match _input_change:
			InputChange.ATTACK:
				InputMap.action_add_event("launch_bomb", event)
				$Settings/Attack.text = "Attack-"+_get_key([event])
				_input_change = InputChange.NONE
			InputChange.INTERACT:
				InputMap.action_add_event("interact", event)
				$Settings/Interact.text = "Interact-"+_get_key([event])
				_input_change = InputChange.NONE
			InputChange.INVENTORY:
				InputMap.action_add_event("inventory", event)
				$Settings/Inventory.text = "Show Inventory-"+_get_key([event])
				_input_change = InputChange.NONE
			InputChange.DISCARD_INVENTORY:
				InputMap.action_add_event("drop_item", event)
				$Settings/DiscardInventory.text = "Discard Inventory Item-"+_get_key([event])
				_input_change = InputChange.NONE
			InputChange.PICKUP:
				InputMap.action_add_event("pickup", event)
				$Settings/Pickup.text = "Pickup Item-"+_get_key([event])
				_input_change = InputChange.NONE
			InputChange.DISCARD:
				InputMap.action_add_event("remove", event)
				$Settings/Discard.text = "Discard Item-"+_get_key([event])
				_input_change = InputChange.NONE
			InputChange.EQUIP:
				InputMap.action_add_event("equip", event)
				$Settings/Equip.text = "Equip Item-"+_get_key([event])
				_input_change = InputChange.NONE


func _get_key(events:Array)->String:
	var event:InputEvent = events[0]
	if event is InputEventKey:
		var scancode:int = event.scancode
		var key_name := OS.get_scancode_string(scancode)
		return key_name
	elif event is InputEventMouseButton:
		var button_index:int = event.get_button_index()
		var button_name := ""
		match button_index:
			1:
				button_name = "Left Click"
			2:
				button_name = "Right Click"
			3:
				button_name = "Middle Click"
		return button_name
	return ""


func _on_Play_pressed()->void:
	_ignore = get_tree().change_scene("res://Main/Main.tscn")


func _on_Settings_pressed()->void:
	_main_menu.hide()
	_settings.show()


func _on_Change_change_input(action:String)->void:
	match action:
		"Attack":
			_input_change = InputChange.ATTACK
			InputMap.action_erase_events("launch_bomb")
		"Equip":
			_input_change = InputChange.EQUIP
			InputMap.action_erase_events("equip")
		"Discard":
			_input_change = InputChange.DISCARD
			InputMap.action_erase_events("remove")
		"Pickup":
			_input_change = InputChange.PICKUP
			InputMap.action_erase_events("pickup")
		"Movement":
			InputMap.action_erase_events("left")
			InputMap.action_erase_events("right")
			InputMap.action_erase_events("up")
			InputMap.action_erase_events("down")
			if _arrow_keys:
				InputMap.action_add_event("left", _get_event("A"))
				InputMap.action_add_event("right", _get_event("D"))
				InputMap.action_add_event("up", _get_event("W"))
				InputMap.action_add_event("down", _get_event("S"))
				_arrow_keys = false
			else:
				InputMap.action_add_event("left", _get_event("LEFT"))
				InputMap.action_add_event("right", _get_event("RIGHT"))
				InputMap.action_add_event("up", _get_event("UP"))
				InputMap.action_add_event("down", _get_event("DOWN"))
				_arrow_keys = true
			$Settings/Movement.text = "Movement-Arrow Keys" if _arrow_keys else "Movement-WASD"
		"Discard_Inventory":
			_input_change = InputChange.DISCARD_INVENTORY
			InputMap.action_erase_events("drop_item")
		"Inventory":
			_input_change = InputChange.INVENTORY
			InputMap.action_erase_events("inventory")
		"Interact":
			_input_change = InputChange.INTERACT
			InputMap.action_erase_events("interact")


func _get_event(event_name:String)->InputEventKey:
	var input := InputEventKey.new()
	input.scancode = OS.find_scancode_from_string(event_name)
	return input


func _on_Back_pressed():
	_main_menu.show()
	_settings.hide()
