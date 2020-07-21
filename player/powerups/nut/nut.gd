extends Area2D

export var speed = 150
export var damage = 0.5
var knockback_vector: = Vector2.ZERO

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_nut_body_entered(body):
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
