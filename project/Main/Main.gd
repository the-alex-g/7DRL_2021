extends Node2D

# signals
signal update_bridges
# enums

# constants

# exported variables

# variables
var _ignore

# onready variables

func _on_spawn_player(player:KinematicBody2D)->void:
	call_deferred("add_child", player)


func _on_spawn_enemies(enemies:Array)->void:
	for enemy in enemies:
		call_deferred("add_child", enemy)
