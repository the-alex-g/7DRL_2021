extends Node

# signals

# enums

# constants

# exported variables

# variables
var _music_bus_index := AudioServer.get_bus_index("Music")
var _SFX_bus_index := AudioServer.get_bus_index("SFX")
var _master_bus_index := AudioServer.get_bus_index("Master")
var _ignore
var _fights := 0

# onready variables
onready var _normal_music := $Normal
onready var _enemy_music := $Enemies
onready var _audio_fade := $AnimationPlayer


func mute_all(value:bool)->void:
	AudioServer.set_bus_mute(_master_bus_index, value)


func change_music_volume(new_volume:int)->void:
	AudioServer.set_bus_volume_db(_music_bus_index, new_volume)


func change_SFX_volume(new_volume:int)->void:
	AudioServer.set_bus_volume_db(_SFX_bus_index, new_volume)


func _on_fight_started()->void:
	if _fights == 0:
		_audio_fade.play("to_enemies")
	_fights += 1


func _on_area_cleared()->void:
	_fights -= 1
	if _fights == 0:
		_audio_fade.play("to_normal")

