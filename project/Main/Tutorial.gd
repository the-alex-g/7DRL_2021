extends Node2D

# signals
signal won
signal update_player_position(new_position)
signal item_picked_up(item)
signal item_equipped(item)
signal powers_updated(powers)
signal update_health(health)
signal player_dead
signal crystals_changed(value)

# enums

# constants

# exported variables

# variables
var _ignore

# onready variables


func _ready()->void:
	$HUD/Label.text = "Use Left Click to throw a detonator towards the mouse pointer. Use WASD to move."
	$HUD/Timer.start(4)
	


func _on_BossSegment0_spawn_boss(boss:KinematicBody2D)->void:
	_ignore = connect("update_player_position", boss, "_on_update_player_position")
	call_deferred("add_child", boss)



func _on_StartSegment_spawn_enemies(enemies:Array)->void:
	for enemy in enemies:
		_ignore = connect("update_player_position", enemy, "_on_update_player_position")
		call_deferred("add_child", enemy)


func _on_StartSegment_spawn_player(player:KinematicBody2D)->void:
	_ignore = player.connect("update_position", self, "_on_update_position")
	_ignore = player.connect("update_powers", self, "_on_powers_update")
	_ignore = player.connect("update_health", self, "_on_player_update_health")
	_ignore = player.connect("dead", self, "_on_player_dead")
	_ignore = connect("item_equipped", player, "_on_item_equipped")
	call_deferred("add_child", player)


func _on_update_position(player_position:Vector2)->void:
	emit_signal("update_player_position", player_position)


func _on_item_picked_up(item:Dictionary)->void:
	if item["type"] == "crystal":
		emit_signal("crystals_changed", 3)
	emit_signal("item_picked_up", item)


func _on_HUD_item_equipped(item:Dictionary)->void:
	emit_signal("item_equipped", item)


func _on_powers_update(powers:Dictionary)->void:
	emit_signal("powers_updated", powers)


func _on_player_update_health(health):
	emit_signal("update_health", health)


func _on_player_dead():
	Jukebox.game_over()
	emit_signal("player_dead")


func _on_Boat_depart()->void:
	emit_signal("won")


func _on_Timer_timeout():
	$HUD/Label.text = "The enemy is very terratorial. They will only attack when you enter their island."
