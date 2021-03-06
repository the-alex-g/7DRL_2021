extends "res://Map/TileSegments/NormalSegment.gd"

# signals
signal spawn_player(player)
# enums

# constants
const PLAYER := "res://Player/Player.tscn"
# exported variables

# variables

# onready variables
onready var player_starting_location := $PlayerStart

func _ready():
	var player:KinematicBody2D = load(PLAYER).instance()
	player.position = player_starting_location.get_global_transform().origin
	emit_signal("spawn_player", player)


