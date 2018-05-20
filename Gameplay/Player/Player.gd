extends Area2D

const HOP_DURATION = 0.25
const JUMP_DISTANCE = 3
const JUMP_DURATION = HOP_DURATION * JUMP_DISTANCE / 2
const HOP_DISTANCE = 1

onready var tween = $Tween
onready var cell_size = get_node("../Floor").cell_size.x

signal coin_collected(newAmount)

var coins_collected = 0

var _position_before_jump = Vector2()
var _desiredPosition = Vector2()
var _jump_power = Vector2()
var _ignore_input = false


func _ready():
	tween.connect("tween_completed", self, "jump_ended")
# ---------------------------------------


func jump_ended(object, key):
	_ignore_input = false
# ---------------------------------------


func _input(event):
	if _ignore_input:
		return
	
	if event.is_action_pressed("long_left"):
		jump(position, Vector2(-1, 0), JUMP_DISTANCE, JUMP_DURATION)
	elif event.is_action_pressed("long_right"):
		jump(position, Vector2(1, 0), JUMP_DISTANCE, JUMP_DURATION)
	elif event.is_action_pressed("long_up"):
		jump(position, Vector2(0, -1), JUMP_DISTANCE, JUMP_DURATION)
	elif event.is_action_pressed("long_down"):
		jump(position, Vector2(0, 1), JUMP_DISTANCE, JUMP_DURATION)
	elif event.is_action_pressed("ui_left"):
		jump(position, Vector2(-1, 0), HOP_DISTANCE, HOP_DURATION)
	elif event.is_action_pressed("ui_right"):
		jump(position, Vector2(1, 0), HOP_DISTANCE, HOP_DURATION)
	elif event.is_action_pressed("ui_up"):
		jump(position, Vector2(0, -1), HOP_DISTANCE, HOP_DURATION)
	elif event.is_action_pressed("ui_down"):
		jump(position, Vector2(0, 1), HOP_DISTANCE, HOP_DURATION)
# ---------------------------------------

func jump(starting_position, direction, jump_distance, jump_duration):
	# Cache needed values. We will use these to calculate potential bounces.
	_position_before_jump = starting_position
	_jump_power = jump_distance
	
	# apply movement vector to current position
	_desiredPosition = starting_position + (direction * jump_distance * cell_size)
	
	start_movement_tween(position, _desiredPosition, jump_duration)
	
	# make sure we start the tween once.
	if not tween.is_active():
		tween.start()
# ---------------------------------------


func collect_coin():
	coins_collected += 1
	emit_signal("coin_collected", coins_collected)
# ---------------------------------------


func prepare_new_bounce(bouncer_position, bounce_direction, added_power):
	print("Position", bouncer_position, ", Bounce direction", bounce_direction, ", Added force: ", added_power)
	
	var distance_vector = _position_before_jump - bouncer_position
	var movement_vector = distance_vector.normalized()
	var distance_covered = get_vector_scalar(distance_vector) / cell_size
	var power_remaining = _jump_power - distance_covered + added_power
	power_remaining += 1
	power_remaining = clamp(power_remaining, 1, 5)
	
	# bounce back
	if typeof(bounce_direction) == TYPE_INT:
		power_remaining = power_remaining * bounce_direction * -1
		jump(bouncer_position, movement_vector, power_remaining, HOP_DURATION * power_remaining) 
	else: # simply use direction provided by the bouncer
		jump(bouncer_position, bounce_direction, power_remaining, HOP_DURATION * power_remaining)
	
	print("distance covered: ", distance_covered, ", power remaining: ", power_remaining, ", movement_vector:", movement_vector)
# ---------------------------------------


func get_vector_scalar(vector2d):
	var scalar
	
	if vector2d.x != 0:
		scalar = vector2d.x
	elif vector2d.y != 0:
		scalar = vector2d.y
	
	return abs(scalar)


func start_movement_tween(start_position, end_position, duration):
	tween.stop(self, "position")
	tween.interpolate_property(self, "position", start_position, end_position, duration, Tween.TRANS_SINE, Tween.EASE_OUT)
	_ignore_input = true