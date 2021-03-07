extends Node2D

# signals
signal update_bridges
signal update_player_position(new_position)
signal item_picked_up(item)
signal item_equipped(item)
signal powers_updated(powers)
signal update_health(health)
# enums

# constants

# exported variables

# variables
var _ignore

# onready variables
onready var _enemies := $Enemies
onready var _hud = $HUD


func _on_spawn_player(player:KinematicBody2D)->void:
	_ignore = player.connect("update_position", self, "_on_update_position")
	_ignore = player.connect("update_powers", self, "_on_powers_update")
	_ignore = player.connect("update_health", self, "_on_player_update_health")
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


func _on_powers_update(powers:Dictionary)->void:
	emit_signal("powers_updated", powers)


func _on_player_update_health(health):
	emit_signal("update_health", health)

