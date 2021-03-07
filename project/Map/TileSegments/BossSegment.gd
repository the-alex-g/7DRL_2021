extends MapSegment

# signals
signal spawn_boss(boss)

# enums

# constants
const BOSS_BRIDGE_ADVANCEMENT := {19:21, 21:23, 20:22, 22:24, 32:33, 33:13, 25:27, 26:28}
const BOSS := "res://Enemies/Boss.tscn"

# exported variables

# variables

# onready variables
onready var _boss_position := $Position2D


func _ready()->void:
	_spawn_boss()


func update_boss_bridges()->void:
	var new_boss_tiles := []
	for tile in _boss_bridge_sections:
		var tile_index:int = tile["index"]
		var tile_position:Vector2 = tile["position"]
		if BOSS_BRIDGE_ADVANCEMENT.has(tile_index):
			var next_tile:int = BOSS_BRIDGE_ADVANCEMENT[tile_index]
			var new_tile := {"position":tile_position, "index":next_tile}
			new_boss_tiles.append(new_tile)
			_tilemap.set_cellv(tile_position, next_tile)
	_boss_bridge_sections = new_boss_tiles


func _spawn_boss()->void:
	var boss:KinematicBody2D = load(BOSS).instance()
	boss.position = _boss_position.get_global_transform().origin
	emit_signal("spawn_boss", boss)

