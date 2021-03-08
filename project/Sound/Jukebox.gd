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

