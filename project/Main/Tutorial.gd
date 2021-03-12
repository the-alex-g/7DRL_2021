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
signal item_hovered(value)

# enums

# constants

# exported variables

# variables
var _ignore
var _area_entered := false
var _enemy_died := false
var _item_picked_up := false

# onready variables
onready var _text_animation := $TextAnimator


func _ready()->void:
	_text_animation.play("Start")


func _on_BossSegment0_spawn_boss(boss:KinematicBody2D)->void:
	_ignore = connect("update_player_position", boss, "_on_update_player_position")
	call_deferred("add_child", boss)



func _on_StartSegment_spawn_enemies(enemies:Array)->void:
	for enemy in enemies:
		enemy.drop_frequency = 1
		_ignore = connect("update_player_position", enemy, "_on_update_player_position")
		enemy.connect("dead", self, "_on_enemy_dead")
		call_deferred("add_child", enemy)


func _on_enemy_dead()->void:
	if not _enemy_died:
		_enemy_died = true
		_text_animation.play("EnemyDied")


func _on_StartSegment_spawn_player(player:KinematicBody2D)->void:
	_ignore = player.connect("update_position", self, "_on_update_position")
	_ignore = player.connect("update_powers", self, "_on_powers_update")
	_ignore = player.connect("update_health", self, "_on_player_update_health")
	_ignore = player.connect("dead", self, "_on_player_dead")
	_ignore = connect("item_equipped", player, "_on_item_equipped")
	_ignore = connect("item_hovered", player, "_set_item_hovered")
	call_deferred("add_child", player)


func _on_update_position(player_position:Vector2)->void:
	emit_signal("update_player_position", player_position)


func _on_item_picked_up(item:Dictionary)->void:
	if not _item_picked_up:
		_text_animation.play("Pickup")
		_item_picked_up = true
	if item["type"] == "crystal":
		_text_animation.play("CrystalPickup")
		emit_signal("crystals_changed", 3)
		emit_signal("item_picked_up", item)
		emit_signal("item_picked_up", item)
		emit_signal("item_picked_up", item)
	emit_signal("item_picked_up", item)
	


func _on_HUD_item_equipped(item:Dictionary)->void:
	emit_signal("item_equipped", item)


func _on_powers_update(powers:Dictionary)->void:
	emit_signal("powers_updated", powers)


func _on_player_update_health(health):
	emit_signal("update_health", health)


func _on_player_dead():
	Jukebox.game_over()
	$HUD/Label.hide()
	emit_signal("player_dead")


func _on_Boat_depart()->void:
	$HUD/Label.hide()
	emit_signal("won")


func _on_Area2D_body_entered(body):
	if not _area_entered:
		if body is Player:
			_area_entered = true
			_text_animation.play("BossIslandEntered")


func _on_HUD_item_hovered(value:bool)->void:
	emit_signal("item_hovered", value)
