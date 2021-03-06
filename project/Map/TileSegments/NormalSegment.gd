extends MapSegment

# signals
signal spawn_enemies(enemies)

# enums

# constants
const ENEMIES := [
	"res://Enemies/Boulderman.tscn"
]

# exported variables
export var _time_before_enemies_respawn := 240

# variables
var _max_enemies := 0
var current_enemies := 0

# onready variables
onready var _enemy_spawn_points := $EnemySpawnPoints
onready var _timer := $Timer


func _ready()->void:
	_max_enemies = _enemy_spawn_points.get_child_count()
	_spawn_enemies()


func _spawn_enemies()->void:
	var enemies := []
	for spawn_point in _enemy_spawn_points.get_children():
		var enemy_index := randi()%ENEMIES.size()
		var enemy_path:String = ENEMIES[enemy_index]
		var enemy:KinematicBody2D = load(enemy_path).instance()
		current_enemies += 1
		enemy.position = spawn_point.get_global_transform().origin
		enemies.append(enemy)
	emit_signal("spawn_enemies", enemies)


