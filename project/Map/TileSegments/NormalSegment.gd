extends MapSegment

# signals
signal spawn_enemies(enemies)

# enums

# constants
const ENEMIES := [
	"res://Enemies/Boulderman.tscn"
]

# exported variables
export var _time_before_enemies_respawn := 120

# variables
var current_enemies := 0
var _can_spawn := false
var _waiting_to_spawn := false

# onready variables
onready var _enemy_spawn_points := $EnemySpawnPoints
onready var _timer := $Timer


func _ready()->void:
	_ignore = _timer.connect("timeout", self, "_on_timer_timeout")
	_timer.one_shot = true
	_spawn_enemies()


func _process(_delta:float)->void:
	if not _waiting_to_spawn:
		return
	elif _waiting_to_spawn and _can_spawn:
		_spawn_enemies()


func _on_timer_timeout()->void:
	if _can_spawn:
		_spawn_enemies()
	else:
		_waiting_to_spawn = true


func _spawn_enemies()->void:
	var enemies := []
	for spawn_point in _enemy_spawn_points.get_children():
		var enemy_index := randi()%ENEMIES.size()
		var enemy_path:String = ENEMIES[enemy_index]
		var enemy:KinematicBody2D = load(enemy_path).instance()
		current_enemies += 1
		enemy.position = spawn_point.get_global_transform().origin
		_ignore = enemy.connect("dead", self, "_on_enemy_dead")
		enemies.append(enemy)
	emit_signal("spawn_enemies", enemies)


func _on_enemy_dead()->void:
	current_enemies -= 1
	if current_enemies == 0:
		_timer.start(_time_before_enemies_respawn)



func _on_VisibilityNotifier2D_viewport_entered(viewport):
	_can_spawn = false


func _on_VisibilityNotifier2D_viewport_exited(viewport):
	_can_spawn = true
