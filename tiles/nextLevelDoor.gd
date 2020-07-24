extends Area2D

export (String, FILE, "*.tscn") var next_level = "res://maps/lvl2.tscn"

func _ready():
	$Sprite.set_deferred('visible', false)
	connect('boss_killed', self, '_on_rat_boss_killed')

func _on_NextLevelDoor_body_entered(body):
	SceneChanger.change_scene(next_level)


func _on_rat_boss_killed():
	$Sprite.set_deferred('visible', true)
	$CollisionShape2D.set_deferred('disabled', false)


func _on_h_boss_killed():
	$Sprite.set_deferred('visible', true)
	$CollisionShape2D.set_deferred('disabled', false)
