extends KinematicBody2D

export (int) var run_speed
export (int) var jump_height
export (int) var gravity

enum {IDLE, RUN, JUMP}
var velocity = Vector2.ZERO
var velocity_previous = Vector2()
var hit_the_ground = false
var state
var anim
var new_anim
var can_jump = true

export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25

var flying_ball = preload("res://Player/Flying_Ball.tscn")

func _ready():
	change_state(IDLE)

func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			new_anim = 'idle'
		RUN:
			new_anim = 'run'
		JUMP:
			new_anim = 'jump_up'

func get_input():
	var dir = 0
	var right = Input.is_action_pressed('go_right')
	var left = Input.is_action_pressed('go_left')
	var jump = Input.is_action_just_pressed('jump')

	if jump && can_jump && is_on_floor():
		change_state(JUMP)
		velocity.y = jump_height

	if right:
		change_state(RUN)
		velocity.x += run_speed
		dir += 1
	if left:
		change_state(RUN)
		velocity.x -= run_speed
		dir -= 1
	if !right and !left and state == RUN:
		change_state(IDLE)

	if dir != 0:
		velocity.x = lerp(velocity.x, dir * run_speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)
func _process(delta):
	if new_anim != anim:
		anim = new_anim
		$Sprite.play(anim)

func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	if state == JUMP:
		if is_on_floor():
			change_state(IDLE)
	velocity = move_and_slide(velocity, Vector2.UP)

	"""----Squeash and Strech----"""
	if not is_on_floor():
		hit_the_ground = false
		$Sprite.scale.y = range_lerp(abs(velocity.y), 0, abs(jump_height), 0.75, 1.75)
		$Sprite.scale.x = range_lerp(abs(velocity.y), 0, abs(jump_height), 1.25, 0.75)
	
	if not hit_the_ground and is_on_floor():
		hit_the_ground = true
		$Sprite.scale.x = range_lerp(abs(velocity_previous.y), 0, abs(1700), 1.2, 2.0)
		$Sprite.scale.y = range_lerp(abs(velocity_previous.y), 0, abs(1700), 0.8, 0.5)
	
	$Sprite.scale.x = lerp($Sprite.scale.x, 1, 1 - pow(0.01, delta))
	$Sprite.scale.y = lerp($Sprite.scale.y, 1, 1 - pow(0.01, delta))

func hit():
	var b = flying_ball.instance()
	get_parent().add_child(b)
	b.set_position(global_position)
	print_debug("died")
	#queue_free()

