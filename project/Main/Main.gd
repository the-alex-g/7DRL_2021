extends Node2D

# signals
signal update_bridges
signal update_player_position(new_position)
# enums

# constants

# exported variables

# variables
var _ignore

# onready variables
onready var _enemies := $Enemies


func _on_spawn_player(player:KinematicBody2D)->void:
	_ignore = player.connect("update_position", self, "_on_update_position")
	call_deferred("add_child", player)


func _on_spawn_enemies(enemies:Array)->void:
	for enemy in enemies:
		_ignore = connect("update_player_position", enemy, "_on_update_player_position")
		call_deferred("add_child", enemy)


func _on_update_position(player_position)->void:
	emit_signal("update_player_position", player_position)
