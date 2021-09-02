extends RigidBody2D

var rng = RandomNumberGenerator.new()
var destroyable = false
func _ready():
	$randTimer.set_wait_time(rng.randf_range(0.1,0.2))
	$randTimer.start()
	$Timer.start()
	$AnimationPlayer.play("flying")
func _on_randTimer_timeout():
	rng.randomize()
	var randx = rng.randf_range(-40.0, 40.0)
	var randy = rng.randf_range(-0.2,-0.1)
	apply_impulse(Vector2(0,-1),Vector2(randx,-20))
func _on_Timer_timeout():
	$randTimer.stop()
	destroyable = true
func _on_Flying_Ball_body_entered(body):
	if destroyable == true:
		queue_free()
		print_debug("is now dead")
