extends Area2D

var stats = PlayerStats

func _on_key_body_entered(body):
	stats.health += 1
	Options.game_sound("pickup")
	queue_free()
