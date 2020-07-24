extends Control

onready var videoButton: = $WindowModeContainer/VideoModeButton
onready var masterVolume: = $VolumeContainer/MasterVolumeSlider
onready var musicVolume: = $VolumeContainer/MusicVolumeSlider
onready var sfxVolume: = $VolumeContainer/SFXVolumeSlider

func _on_BackButton_pressed():

	SceneChanger.change_scene("res://screens_menus/StartMenu.tscn", 0.1)
	

func _ready():
	Options.choose_music('stop')
	$BackButton.grab_focus()
	if Options.fullscreen:
		videoButton.set_text('Fullscreen')
	else:
		videoButton.set_text('Windowed')


func _on_VideoModeButton_pressed():
	Options.set_fullscreen()
	
	if Options.fullscreen:
		videoButton.set_text('Fullscreen')
	else:
		videoButton.set_text('Windowed')


func _on_MasterVolumeSlider_value_changed(value):
	Options.Master_Volume = 2000 * masterVolume.value


func _on_MusicVolumeSlider_value_changed(value):
	Options.Music_Volume = 2000 * musicVolume.value


func _on_SFXVolumeSlider_value_changed(value):
	Options.Effects_Volume = 2000 * sfxVolume.value
