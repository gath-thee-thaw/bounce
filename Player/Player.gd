extends KinematicBody2D

const UP = Vector2(0, -1)
export var gravity = 35
export var speed = 700
export var jump_height = -1200

export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25

var motion = Vector2()
var motion_previous = Vector2()

var hit_the_ground = false

func _physics_process(delta):
	var dir = 0
	motion.y += gravity
	
	if Input.is_action_pressed("go_left"):
		motion.x = -speed
		dir += 1
	elif Input.is_action_pressed("go_right"):
		motion.x = speed
		dir -= 1
		
	if dir != 0:
		motion.x = lerp(motion.x, dir * speed, acceleration)
	else:
		motion.x = lerp(motion.x, 0, friction)
	
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			motion.y = jump_height
	""""
	var collision = move_and_collide(motion * delta)
	if collision:
		motion = motion.bounce(collision.normal)
	"""
	motion_previous = motion
	motion = move_and_slide(motion, UP, false)
	
	if not is_on_floor():
		hit_the_ground = false
		$Sprite.scale.y = range_lerp(abs(motion.y), 0, abs(jump_height), 0.75, 1.75)
		$Sprite.scale.x = range_lerp(abs(motion.y), 0, abs(jump_height), 1.25, 0.75)
	
	if not hit_the_ground and is_on_floor():
		hit_the_ground = true
		$Sprite.scale.x = range_lerp(abs(motion_previous.y), 0, abs(1700), 1.2, 2.0)
		$Sprite.scale.y = range_lerp(abs(motion_previous.y), 0, abs(1700), 0.8, 0.5)
	
	$Sprite.scale.x = lerp($Sprite.scale.x, 1, 1 - pow(0.01, delta))
	$Sprite.scale.y = lerp($Sprite.scale.y, 1, 1 - pow(0.01, delta))
