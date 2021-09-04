extends Node

func _ready():
	Engine.set_target_fps(Engine.get_iterations_per_second()) #this fixes the camera jitter
	pass
func _process(_delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
