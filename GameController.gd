extends Node

func _ready():
	Engine.set_target_fps(Engine.get_iterations_per_second()) #this fixes the camera jitter
