class_name MapSegment
extends Node2D

# signals

# enums

# constants
const BRIDGE_INDEXES := [13, 14]
const CONNECTION_INDEXES := [15, 16, 17, 18]
const CONNECTION_TO_SIDE := {15:12, 16:10, 17:11, 18:9}
const BOSS_BRIDGE_SECTIONS := [19, 20, 32, 33, 26, 25]

# exported variables

# variables
var _ignore
var north := false
var south := false
var east := false
var west := false
var _bridges := []
var _connections := []
var _bridges_on_edge := []
var _connections_on_edge := []
var _tiles := []
var _boss_bridge_sections := []

# onready variables
onready var _tilemap := $TileMap


func _ready()->void:
	_get_tiles()
	for tile in _tiles:
		var tile_index:int = tile["index"]
		if BRIDGE_INDEXES.has(tile_index):
			_bridges.append(tile)
		elif CONNECTION_INDEXES.has(tile_index):
			_connections.append(tile)
		elif BOSS_BRIDGE_SECTIONS.has(tile_index):
			_boss_bridge_sections.append(tile)
			
	for tile in _bridges:
		var tile_position:Vector2 = tile["position"]
		var tile_index:int = tile["index"]
		if tile_index == 13:
			var tile_above:int = _tilemap.get_cellv(tile_position+Vector2.UP)
			var tile_below:int = _tilemap.get_cellv(tile_position+Vector2.DOWN)
			if tile_above == -1:
				tile["side"] = "north"
				_bridges_on_edge.append(tile)
			elif tile_below == -1:
				tile["side"] = "south"
				_bridges_on_edge.append(tile)
		elif tile_index == 14:
			var tile_left:int = _tilemap.get_cellv(tile_position+Vector2.LEFT)
			var tile_right:int = _tilemap.get_cellv(tile_position+Vector2.RIGHT)
			if tile_left == -1:
				tile["side"] = "west"
				_bridges_on_edge.append(tile)
			elif tile_right == -1:
				tile["side"] = "east"
				_bridges_on_edge.append(tile)
				
	for tile in _connections:
		var tile_position:Vector2 = tile["position"]
		var tile_index:int = tile["index"]
		match tile_index:
			15:
				var new_tile_position := tile_position+Vector2.DOWN
				var tile_below:int = _tilemap.get_cellv(new_tile_position)
				var new_tile := _get_tile(tile_below, new_tile_position)
				new_tile["side"] = "south"
				if _check_if_has_tile(new_tile, _bridges_on_edge) or new_tile["index"] == -1:
					tile["side"] = "south"
					_connections_on_edge.append(tile)
			16:
				var new_tile_position := tile_position+Vector2.RIGHT
				var tile_right:int = _tilemap.get_cellv(new_tile_position)
				var new_tile := _get_tile(tile_right, new_tile_position)
				new_tile["side"] = "east"
				if _check_if_has_tile(new_tile, _bridges_on_edge) or new_tile["index"] == -1:
					tile["side"] = "east"
					_connections_on_edge.append(tile)
			17:
				var new_tile_position := tile_position+Vector2.UP
				var tile_above:int = _tilemap.get_cellv(new_tile_position)
				var new_tile := _get_tile(tile_above, new_tile_position)
				new_tile["side"] = "north"
				if _check_if_has_tile(new_tile, _bridges_on_edge) or new_tile["index"] == -1:
					tile["side"] = "north"
					_connections_on_edge.append(tile)
			18:
				var new_tile_position := tile_position+Vector2.LEFT
				var tile_left:int = _tilemap.get_cellv(new_tile_position)
				var new_tile := _get_tile(tile_left, new_tile_position)
				new_tile["side"] = "west"
				if _check_if_has_tile(new_tile, _bridges_on_edge) or new_tile["index"] == -1:
					tile["side"] = "west"
					_connections_on_edge.append(tile)
					
	for tile in _bridges_on_edge:
		var tile_side:String = tile["side"]
		var tile_position:Vector2 = tile["position"]
		if tile_side == "south" and south:
			_tilemap.set_cellv(tile_position, -1)
		if tile_side == "north" and north:
			_tilemap.set_cellv(tile_position, -1)
		if tile_side == "east" and east:
			_tilemap.set_cellv(tile_position, -1)
		if tile_side == "west" and west:
			_tilemap.set_cellv(tile_position, -1)
			
	for tile in _connections_on_edge:
		var tile_index:int = tile["index"]
		var tile_side:String = tile["side"]
		var tile_position:Vector2 = tile["position"]
		var tile_replacement:int = CONNECTION_TO_SIDE[tile_index]
		if tile_side == "south" and south:
			_tilemap.set_cellv(tile_position, tile_replacement)
		if tile_side == "north" and north:
			_tilemap.set_cellv(tile_position, tile_replacement)
		if tile_side == "east" and east:
			_tilemap.set_cellv(tile_position, tile_replacement)
		if tile_side == "west" and west:
			_tilemap.set_cellv(tile_position, tile_replacement)


func _get_tile(tile_index:int, tile_position:Vector2)->Dictionary:
	var tile := {"position":tile_position, "index":tile_index}
	return tile


func _get_tiles()->void:
	var tile_positions:Array = _tilemap.get_used_cells()
	for tile_position in tile_positions:
		var tile_index:int = _tilemap.get_cellv(tile_position)
		var tile := {"position":tile_position, "index":tile_index}
		_tiles.append(tile)


func _check_if_has_tile(tile:Dictionary, array_to_check:Array)->bool:
	for item in array_to_check:
		if item.hash() == tile.hash():
			return true
	return false

