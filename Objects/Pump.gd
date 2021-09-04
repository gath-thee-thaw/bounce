extends Area2D

func _on_Pump_body_entered(body):
	if body.has_method("expand"):
		body.expand()
