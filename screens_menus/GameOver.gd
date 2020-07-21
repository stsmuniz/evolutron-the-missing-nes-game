extends Control

onready var animationPlayer = $AnimationPlayer

func _ready():
	animationPlayer.play("showText")
	Options.choose_music("gameover")

func _unhandled_input(event):
	if event.is_action_pressed("start"):
		SceneChanger.change_scene("res://screens_menus/StartMenu.tscn", 0.1)
	if event.is_action_pressed("a"):
		SceneChanger.change_scene("res://screens_menus/StartMenu.tscn", 0.1)
	if event.is_action_pressed("b"):
		SceneChanger.change_scene("res://screens_menus/StartMenu.tscn", 0.1)

func _on_Timer_timeout():
	SceneChanger.change_scene("res://screens_menus/StartMenu.tscn", 0.1)
