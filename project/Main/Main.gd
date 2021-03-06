extends Node2D

# signals
signal update_bridges
signal won
signal item_hovered(value)
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
var _crystals := 0

# onready variables
onready var _enemies := $Enemies
onready var _hud = $HUD


func _on_spawn_player(player:KinematicBody2D)->void:
	_ignore = player.connect("update_position", self, "_on_update_position")
	_ignore = player.connect("update_powers", self, "_on_powers_update")
	_ignore = player.connect("update_health", self, "_on_player_update_health")
	_ignore = player.connect("dead", self, "_on_player_dead")
	_ignore = connect("item_equipped", player, "_on_item_equipped")
	_ignore = connect("item_hovered", player, "_set_item_hovered")
	call_deferred("add_child", player)


func _on_spawn_enemies(enemies:Array)->void:
	for enemy in enemies:
		_ignore = connect("update_player_position", enemy, "_on_update_player_position")
		call_deferred("add_child", enemy)


func _on_spawn_boss(boss:KinematicBody2D)->void:
	_ignore = connect("update_player_position", boss, "_on_update_player_position")
	call_deferred("add_child", boss)


func _on_update_position(player_position:Vector2)->void:
	emit_signal("update_player_position", player_position)


func _on_item_picked_up(item:Dictionary)->void:
	if item["type"] == "crystal":
		emit_signal("update_bridges")
		_crystals += 1
		emit_signal("crystals_changed", _crystals)
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


func _on_game_won()->void:
	emit_signal("won")


func _on_HUD_item_hovered(value:bool)->void:
	emit_signal("item_hovered", value)
