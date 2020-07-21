extends Control

onready var animationPlayer = $AnimationPlayer

func _ready():
	animationPlayer.play("roll")
	Options.game_music("ending")
