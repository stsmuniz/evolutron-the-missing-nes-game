extends Area2D


func _on_key_body_entered(body):
	body.keys += 1
	Options.game_sound("pickup")
	queue_free()
