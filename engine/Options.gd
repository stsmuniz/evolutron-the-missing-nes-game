extends Control

# temporary

const SAVE_PATH = "res://save.json"

var settings = {}
var play_Music = 1
var play_Effects = 1
var new_choice = 1
var song
var menu = true
var paused = false
var pause_menu = false

# saved

var Master_Volume = 2000
var Music_Volume = 2000
var Effects_Volume = 2000
var Master_Mute = false
var Music_Mute = false
var Effects_Mute = false
var fullscreen = false


func _ready():
	load_game()
	choose_music()

func _process(delta):
	if (Master_Volume > 0 and Music_Volume > 0):
		play_Music = int(((Master_Volume / 2000) * (Music_Volume / 2000)) * 2000)
	else:
		play_Music = 1
	
	if (Master_Volume > 0 and Effects_Volume > 0):
		play_Music = int(((Master_Volume / 2000) * (Effects_Volume / 2000)) * 2000)
	else:
		play_Effects = 1
	
	#$Music.set_max_distance(play_Music)
	
func _input(event):
	pass
	
func choose_music(music = "none"):
	game_music(music)


func game_music(song_index):
	match song_index:
		1: 
			song = load("res://music/Asking_Questions_in_an_Eight_Bit_Basement.ogg")
		2:
			song = load("res://music/Bad_Graffix_Crow.ogg")
		"boss":
			song = load("res://music/Chiptune_Throne_Room_sans_Percussion.ogg")
		"ending":
			song = load("res://music/Eight_Bit_Hollow_Night.ogg")
		"cutscene":
			song = load("res://music/Conferring_with_an_Old_Master.ogg")
		"menu":
			song = load("res://music/Conferring_with_an_Old_Master.ogg")
		"gameover":
			song = load("res://music/Chiptune_Nobility.ogg")
		"none":
			song = null
		"stop":
			song = null

	if song != null:
		song.loop = true
		$Music.set_stream(song)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -10)
		$Music.play(0.0)
	elif song == "stop":
		$Music.stop()
		


func game_sound(song_index):
	match song_index:
		"bite": 
			song = load("res://sounds/bite.wav")
		"boss_death":
			song = load("res://sounds/boss_death.wav")
		"hit":
			song = load("res://sounds/hit.wav")
		"pickup":
			song = load("res://sounds/pickup.wav")
		"select_option":
			song = load("res://sounds/select_option.wav")
		"company_name":
			song = load("res://sounds/company_name.wav")
		"shot":
			song = load("res://sounds/shot.wav")
		"none":
			song = null
		"stop":
			song = null

	if song != null:
		$Effect.set_stream(song)
		$Effect.play()
	elif song == "stop":
		$Effect.stop()
	
func save_game():
	settings = {
		fullscreen = fullscreen,
		Master_Volume = Master_Volume,
		Master_Mute = Master_Mute,
		Music_Volume = Music_Volume,
		Music_Mute = Music_Mute,
		Effects_Volume = Effects_Volume,
		Effects_Mute = Effects_Mute
	}
	
	var save_file = File.new()
	save_file.open(SAVE_PATH, File.WRITE)
	save_file.store_line(to_json(settings))
	save_file.close()


func load_game():
	var save_file = File.new()
	if not save_file.file_exists(SAVE_PATH):
		return
	
	save_file.open(SAVE_PATH, File.READ)
	
	var data = {}
	data = parse_json(save_file.get_as_text())
	
	Master_Volume = data['Master_Volume']
	Music_Volume = data['Music_Volume']
	Effects_Volume = data['Effects_Volume']
	Master_Mute = data['Master_Mute']
	Music_Mute = data['Music_Mute']
	Effects_Mute = data['Effects_Mute']
	fullscreen = data['fullscreen']
	
func set_fullscreen():
	fullscreen = !fullscreen
	OS.window_fullscreen = fullscreen
