extends Control

onready var animationPlayer = $AnimationPlayer

func playSfx():
	Options.game_sound("company_name")

func finish():
	SceneChanger.change_scene("res://screens_menus/StartMenu.tscn", 1)
