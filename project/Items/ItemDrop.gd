extends Node2D

# signals
signal picked_up(item)

# enums

# constants
const ITEM_TYPES := [
	{"name":"Robe of Speed", "type":"cloak", "anim_name":"cloak_blue", "player_anim_type":"robe_blue", "properties":{"_speed":20}},
	{"name":"Robe of the Dying Sun", "type":"cloak", "anim_name":"cloak_red", "player_anim_type":"robe_red", "properties":{"_damage_dealt":2, "_damage_taken":1}},
	{"name":"Robe of the Living Garden", "type":"cloak", "anim_name":"cloak_green", "player_anim_type":"robe_green", "properties":{"_damage_taken":-1}},
	{"name":"Armored Robe", "anim_name":"cloak_armored", "type":"cloak", "player_anim_type":"robe_armored", "properties":{"_armor":1}},
	{"name":"Robe of Quick Healing", "type":"cloak", "anim_name":"cloak_green", "player_anim_type":"robe_green", "properties":{"_heal_delay":-1}},
	{"name":"Staff of Dmaje", "type":"staff", "anim_name":"staff_pronged", "player_anim_type":"staff_pronged", "properties":{"_damage_dealt":1, "_damage_taken":1}},
	{"name":"Staff of Channeling", "type":"staff", "anim_name":"staff_case", "player_anim_type":"staff_case", "properties":{"_damage_dealt":-1, "_damage_taken":-1}},
	{"name":"Staff of Healing", "type":"staff", "anim_name":"staff_case", "player_anim_type":"staff_case", "properties":{"_heal_delay":-1}},
	{"name":"Rod of Defense", "type":"staff", "anim_name":"staff_pronged", "player_anim_type":"staff_pronged", "properties":{"_armor":1}},
	{"name":"Channeled Detonator", "type":"detonator", "anim_name":"detonator_green", "player_anim_type":"green", "properties":{"_damage_taken":-1}},
	{"name":"Solar Detonator", "type":"detonator", "anim_name":"detonator_red", "player_anim_type":"red", "properties":{"_damage_dealt":1, "_damage_taken":1}},
	{"name":"Swift Detonator", "type":"detonator", "anim_name":"detonator_blue", "player_anim_type":"blue", "properties":{"_cooldown_time":-0.8}},
]

# exported variables

# variables
var _ignore
var _item:Dictionary
var _pickup := false
var _player:KinematicBody2D = null
var _label := ItemLabel.new()

# onready variables
onready var _item_image := $AnimatedSprite


func _ready()->void:
	var item_index := randi()%ITEM_TYPES.size()
	_item = ITEM_TYPES[item_index]
	_item_image.play(_item["anim_name"])
	_ignore = connect("picked_up", get_parent(), "_on_item_picked_up")


func _process(_delta)->void:
	if not _pickup:
		return
	if Input.is_action_just_pressed("interact"):
		z_index = 10
		_label.generate_text(_item)
		add_child(_label)
	if Input.is_action_just_pressed("remove"):
		queue_free()
	if Input.is_action_just_pressed("pickup"):
		emit_signal("picked_up", _item)
		queue_free()


func _on_ItemDrop_body_entered(body)->void:
	if body is Player:
		_player = body
		_pickup = true


func _on_ItemDrop_body_exited(body)->void:
	if body is Player:
		z_index = 0
		_pickup = false
		_player = null
		_label.queue_free()
		_label = ItemLabel.new()
