extends CanvasLayer

# signals
signal item_picked_up(item)
signal item_equipped(item)
signal powers_updated(powers)

# enums

# constants

# exported variables

# variables
var _ignore
var _is_inventory_up := false
var _player_dead := false

# onready variables
onready var _healthbar := $Inventory/TextureRect/TextureProgress
onready var _tween := $Tween
onready var _animation_player := $AnimationPlayer


func _ready()->void:
	_animation_player.play("fade_in")


func _process(_delta:float)->void:
	if not _player_dead:
		if Input.is_action_just_pressed("inventory"):
			if _is_inventory_up:
				_animation_player.play("down")
				_is_inventory_up = false
			else:
				_animation_player.play("up")
				_is_inventory_up = true


func _on_Main_item_picked_up(item:Dictionary)->void:
	emit_signal("item_picked_up", item)


func _on_GridContainer_equipped_item(item:Dictionary)->void:
	emit_signal("item_equipped", item)


func _on_Main_powers_updated(powers:Dictionary)->void:
	emit_signal("powers_updated", powers)


func _on_Main_update_health(current_health:int)->void:
	var difference:float = abs(_healthbar.value-current_health)
	var interpolation_time := difference/30.0
	_tween.interpolate_property(_healthbar, "value", null, current_health, interpolation_time)
	_tween.start()


func _on_Main_player_dead():
	_player_dead = true
	$Foreground/Label.text = "Let's try that again."
	game_over()


func game_over()->void:
	_animation_player.stop()
	_animation_player.play("fade_out")


func _on_Button_pressed():
	_ignore = get_tree().change_scene("res://Main/Main.tscn")


func _on_Main_pressed():
	_ignore = get_tree().change_scene("res://Main/MainMenu.tscn")


func _on_Main_won():
	$Foreground/Label.text = "The stabilizer has been powered. \n It will keep the star at bay, but for how long?"
	_animation_player.play("win")
