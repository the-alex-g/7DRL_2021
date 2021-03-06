extends Enemy

# signals

# enums

# constants
const CRYSTAL_DROP := "res://Items/Crystal.tscn"

# exported variables

# variables
var _can_hit := true
var level := 1

# onready variables
onready var _punch_range := $HitArea
onready var _hit_cooldown_timer := $HitCooldownTimer
onready var _punch_anim_timer := $PunchAnimTimer


func _ready()->void:
	rotation = 0.5*PI
	drop_frequency = 1
	_damage = level+1
	_health = (6*level)+3


func _process(_delta)->void:
	if not _can_hit:
		return
	else:
		var _bodies:Array = _punch_range.get_overlapping_bodies()
		for body in _bodies:
			if body is Player and _state != State.DEAD:
				hit(body)


func hit(body:Node2D)->void:
	body.take_damage(_damage)
	_can_hit = false
	_state = State.ATTACKING
	_hit_cooldown_timer.start(1)
	_punch_anim_timer.start(0.5)


func _on_HitArea_body_entered(body:Node2D)->void:
	if body is Player and _can_hit and _state != State.DEAD:
		hit(body)


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
