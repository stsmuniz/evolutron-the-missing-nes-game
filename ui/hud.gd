extends CanvasLayer


func _on_player_key_changed(value):
	$keyQty.text = str(value)
