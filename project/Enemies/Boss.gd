extends Enemy

# signals

# enums

# constants
const CRYSTAL_DROP := "res://Items/Crystal.tscn"

# exported variables

# variables
var _can_hit := true

# onready variables
onready var _punch_range := $HitArea
onready var _hit_cooldown_timer := $HitCooldownTimer
onready var _punch_anim_timer := $PunchAnimTimer


func _ready()->void:
	_health = 9


func _on_HitArea_body_entered(body:Node2D)->void:
	if body is Player and _can_hit and _state != State.DEAD:
		body.take_damage(_damage)
		_can_hit = false
		_state = State.ATTACKING
		_hit_cooldown_timer.start()
		_punch_anim_timer.start()


func _on_HitCooldownTimer_timeout()->void:
	_can_hit = true


func _on_PunchAnimTimer_timeout()->void:
	if _state != State.DEAD:
		_state = State.ACTIVE


func _on_Boss_dead()->void:
	_spawn_crystal()


func _spawn_crystal()->void:
	var crystal:Area2D = load(CRYSTAL_DROP).instance()
	crystal.position = get_global_transform().origin
	get_parent().add_child(crystal)
