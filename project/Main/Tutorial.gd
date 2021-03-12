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
var _area_entered := false
var _enemy_died := false
var _item_picked_up := false

# onready variables


func _ready()->void:
	$HUD/Label.text = "Now, don't go dashing off anywhere before I'm done speaking."
	$Timer4.start(4)


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
		$HUD/Label.text = "Some enemies will drop treasure. When next to it, press E to see what it does. Press F to pick it up. Press R to throw it away."


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
	if not _item_picked_up:
		$HUD/Label.text = "Press I to expand your inventory. Left click on an item in the bottom row to equip it. Right click to throw it away."
		$Timer3.start(6)
		_item_picked_up = true
	if item["type"] == "crystal":
		$HUD/Label.text = "Once you have picked up three Othal crystals, find the boat we have waiting for you. It will take you to the stabilizer."
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


func _on_Timer_timeout():
	$HUD/Label.text = "The enemy is very terratorial. They will only attack when you enter their island."
	$Timer2.start(6)


func _on_Timer2_timeout():
	$HUD/Label.text = "Be warned, however. Using your powers will take some of your energy. If you throw too many bombs, you could die. Luckily, you regenerate quickly. \nOkay, let's see what you can do now."


func _on_Timer3_timeout():
	$HUD/Label.text = "The shield icon in your inventory is the amount of armor you have, the circle is the damage you do, and the arrow is the cost of your attacks."


func _on_Timer4_timeout():
	$HUD/Label.text = "Use Left Click to throw a detonator towards the mouse pointer. Use WASD to move."
	$Timer.start(6)


func _on_Area2D_body_entered(body):
	if not _area_entered:
		if body is Player:
			_area_entered = true
			$HUD/Label.text = "The guardians protect the crystals we need. Once you enter their islands, you cannot escape until they are dead."
