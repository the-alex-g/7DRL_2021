extends Node2D

# signals
signal update_bridges
signal update_player_position(new_position)
signal item_picked_up(item)
signal item_equipped(item)
# enums

# constants

# exported variables

# variables
var _ignore

# onready variables
onready var _enemies := $Enemies


func _on_spawn_player(player:KinematicBody2D)->void:
	_ignore = player.connect("update_position", self, "_on_update_position")
	_ignore = connect("item_equipped", player, "_on_item_equipped")
	call_deferred("add_child", player)


func _on_spawn_enemies(enemies:Array)->void:
	for enemy in enemies:
		_ignore = connect("update_player_position", enemy, "_on_update_player_position")
		call_deferred("add_child", enemy)


func _on_update_position(player_position:Vector2)->void:
	emit_signal("update_player_position", player_position)


func _on_item_picked_up(item:Dictionary)->void:
	emit_signal("item_picked_up", item)


func _on_HUD_item_equipped(item:Dictionary)->void:
	emit_signal("item_equipped", item)
