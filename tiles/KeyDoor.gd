extends StaticBody2D

onready var sprite = $Sprite
onready var collision = $CollisionShape2D
onready var area2D = $Area2D

func _on_Area2D_body_entered(body):
	if body.name == 'player' && body.keys > 0:
		body.keys = body.keys - 1
		sprite.frame = 1
		collision.queue_free()
		area2D.queue_free()

