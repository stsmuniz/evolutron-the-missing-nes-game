extends Area2D



func _on_nut_body_entered(body):
	PlayerStats.powerup_shot = true
	Options.game_sound("pickup")
	queue_free()
