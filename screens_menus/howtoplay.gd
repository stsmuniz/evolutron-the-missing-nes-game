extends Control

func _input(event):
	if event.is_action_pressed("start"):
		SceneChanger.change_scene("res://screens_menus/CompanyLogo.tscn", 0.1)
