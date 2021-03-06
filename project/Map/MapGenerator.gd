extends Node2D

# signals

# enums

# constants
const _MAP_SEGMENT := "res://Map/TileSegments/Segment"
const _BOSS_SEGMENT := "res://Map/TileSegments/BossSegment"
const _MAP_SEGMENT_EXTENSION := ".tscn"
const _SEGMENT_SIZE := 9
const _CELL_SIZE := 32
const _TILE_SEGMENTS := 1
const _MAP_POSITIONS := [
	{"position":Vector2(0,0), "sides":{"north":true, "south":false, "west":true, "east":false}},
	{"position":Vector2(0,1), "sides":{"north":false, "south":true, "west":true, "east":false}},
	{"position":Vector2(1,0), "sides":{"north":true, "south":false, "west":false, "east":true}},
	{"position":Vector2(1,1), "sides":{"north":false, "south":true, "west":false, "east":true}},
]

# exported variables

# variables
var _ignore
var _boss_segment_0:Node2D
var _boss_segment_1:Node2D
var _boss_segment_2:Node2D

# onready variables
onready var _map_segments := $MapSegments


func _ready():
	randomize()
	for i in 3:
		var map_positions := _MAP_POSITIONS.size()
		var index := randi()%map_positions
		var map_position:Dictionary = _MAP_POSITIONS[index]
		_MAP_POSITIONS.remove(index)
		var boss_segment_to_load := _BOSS_SEGMENT+str(i)+_MAP_SEGMENT_EXTENSION
		var boss_segment:Node2D = load(boss_segment_to_load).instance()
		var tile_segment_position:Vector2 = map_position["position"]
		tile_segment_position *= _SEGMENT_SIZE*_CELL_SIZE
		boss_segment.position = tile_segment_position
		for side in map_position["sides"]:
			var side_value:bool = map_position["sides"][side]
			boss_segment.set(side, side_value)
		_map_segments.add_child(boss_segment)
		set("_boss_segment_"+str(i), boss_segment)

	for spot in _MAP_POSITIONS:
		var tile_segment_position:Vector2 = spot["position"]
		var tile_segment_index := randi()%_TILE_SEGMENTS
		var segment_to_load := _MAP_SEGMENT+str(tile_segment_index)+_MAP_SEGMENT_EXTENSION
		var segment:Node2D = load(segment_to_load).instance()
		tile_segment_position *= _SEGMENT_SIZE*_CELL_SIZE
		segment.position = tile_segment_position
		for side in spot["sides"]:
			var side_value:bool = spot["sides"][side]
			segment.set(side, side_value)
		_map_segments.add_child(segment)


func _on_Main_update_bridges():
	_boss_segment_0.update_boss_bridges()
	_boss_segment_1.update_boss_bridges()
	_boss_segment_2.update_boss_bridges()
