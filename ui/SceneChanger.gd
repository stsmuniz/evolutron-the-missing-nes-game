extends CanvasLayer

signal scene_changed()

onready var animationPlayer = $AnimationPlayer
onready var black = $TransitionOverlay/ColorRect

func change_scene(path: String, delay = 0.5):
	yield(get_tree().create_timer(delay), "timeout")
	animationPlayer.play("FadeOut")
	yield(animationPlayer, "animation_finished")
	assert(get_tree().change_scene(path) == OK)
	animationPlayer.play_backwards("FadeOut")
	yield(animationPlayer, "animation_finished")
	emit_signal("scene_changed")
