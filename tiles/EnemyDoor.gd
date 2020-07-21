extends StaticBody2D

onready var camera = get_node("../../Camera2D")
onready var player = get_node("../../player")

func _ready():
	$AnimationPlayer.play("open")
	
func _process(delta):
	if camera.grid_pos == camera.get_grid_pos(global_position):

		if camera.get_enemies() == 0:
			if $AnimationPlayer.assigned_animation != "open":
				$AnimationPlayer.play("open")
		elif !$Area2D.get_overlapping_bodies().has(player):
			if $AnimationPlayer.assigned_animation != "close":
				$AnimationPlayer.play("close")
	else:
		if $AnimationPlayer.assigned_animation != "open":
			$AnimationPlayer.play("open")
