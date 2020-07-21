extends Area2D

var stats = PlayerStats

func _on_key_body_entered(body: KinematicBody2D):
	if body.get_collision_layer_bit(1):
		stats.max_health += 1
		stats.health += 1
		Options.game_sound("pickup")
		queue_free()
