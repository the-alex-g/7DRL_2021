extends Node2D

# signals

# enums

# constants
const _MAP_SEGMENT := "res://Map/TileSegments/Segment"
const _BOSS_SEGMENT := "res://Map/TileSegments/BossSegment"
const _PLAYER_START_SEGMENT := "res://Map/TileSegments/StartSegment.tscn"
const _WIN_SEGMENT := "res://Map/TileSegments/WinSegment.tscn"
const _MAP_SEGMENT_EXTENSION := ".tscn"
const _SEGMENT_SIZE := 9
const _CELL_SIZE := 32
const _TILE_SEGMENTS := 3

# exported variables

# variables
var _ignore
var _boss_segment_0:Node2D
var _boss_segment_1:Node2D
var _boss_segment_2:Node2D
var _map_positions := [
	{"position":Vector2(0,0), "sides":{"north":true, "south":false, "west":true, "east":false}},
	{"position":Vector2(0,1), "sides":{"north":false, "south":false, "west":false, "east":false}},
	{"position":Vector2(0,2), "sides":{"north":false, "south":true, "west":true, "east":false}},
	{"position":Vector2(1,0), "sides":{"north":true, "south":false, "west":false, "east":false}},
	{"position":Vector2(2,0), "sides":{"north":true, "south":false, "west":false, "east":false}},
	{"position":Vector2(1,1), "sides":{"north":false, "south":false, "west":false, "east":false}},
	{"position":Vector2(2,1), "sides":{"north":false, "south":false, "west":false, "east":false}},
	{"position":Vector2(1,2), "sides":{"north":false, "south":false, "west":false, "east":false}},
	{"position":Vector2(2,2), "sides":{"north":false, "south":true, "west":false, "east":true}},
	{"position":Vector2(1,3), "sides":{"north":false, "south":true, "west":true, "east":true}},
	{"position":Vector2(3,0), "sides":{"north":true, "south":false, "west":false, "east":true}},
	{"position":Vector2(3,1), "sides":{"north":false, "south":true, "west":false, "east":true}},
]

# onready variables
onready var _map_segments := $MapSegments


func _ready():
	randomize()
	var win_segment = load(_WIN_SEGMENT).instance()
	var what := Vector2(-2,1)
	what *= _SEGMENT_SIZE*_CELL_SIZE
	win_segment.position = what
	_ignore = get_parent().connect("crystals_changed", win_segment, "_on_crystals_changed")
	_map_segments.add_child(win_segment)
	for i in 4:
		var map_positions := _map_positions.size()
		var index := randi()%map_positions
		var map_position:Dictionary = _map_positions[index]
		_map_positions.remove(index)
		var tile_segment_position:Vector2 = map_position["position"]
		tile_segment_position *= _SEGMENT_SIZE*_CELL_SIZE
		if i < 3:
			var boss_segment_to_load := _BOSS_SEGMENT+str(i)+_MAP_SEGMENT_EXTENSION
			var boss_segment:Node2D = load(boss_segment_to_load).instance()
			boss_segment.position = tile_segment_position
			_ignore = boss_segment.connect("spawn_boss", get_parent(), "_on_spawn_boss")
			for side in map_position["sides"]:
				var side_value:bool = map_position["sides"][side]
				boss_segment.set(side, side_value)
			_map_segments.add_child(boss_segment)
			set("_boss_segment_"+str(i), boss_segment)
		else:
			var start_segment:Node2D = load(_PLAYER_START_SEGMENT).instance()
			start_segment.position = tile_segment_position
			for side in map_position["sides"]:
				var side_value:bool = map_position["sides"][side]
				start_segment.set(side, side_value)
			_ignore = start_segment.connect("spawn_player", get_parent(), "_on_spawn_player")
			_ignore = start_segment.connect("spawn_enemies", get_parent(), "_on_spawn_enemies")
			_map_segments.add_child(start_segment)
			
	for map_position in _map_positions:
		var tile_segment_position:Vector2 = map_position["position"]
		var tile_segment_index := randi()%_TILE_SEGMENTS
		var segment_to_load := _MAP_SEGMENT+str(tile_segment_index)+_MAP_SEGMENT_EXTENSION
		var segment:Node2D = load(segment_to_load).instance()
		tile_segment_position *= _SEGMENT_SIZE*_CELL_SIZE
		segment.position = tile_segment_position
		for side in map_position["sides"]:
			var side_value:bool = map_position["sides"][side]
			segment.set(side, side_value)
		_ignore = segment.connect("spawn_enemies", get_parent(), "_on_spawn_enemies")
		_map_segments.add_child(segment)


func _on_Main_update_bridges():
	_boss_segment_0.update_boss_bridges()
	_boss_segment_1.update_boss_bridges()
	_boss_segment_2.update_boss_bridges()
