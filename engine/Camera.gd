extends Camera2D

const HUD_THICKNESS = 48

var resolution = Vector2(256, 192)
var grid_pos = Vector2.ZERO

func _process(delta):
	if get_node('../player') != null:
		var player_grid_pos = get_grid_pos(get_node('../player').global_position)
		global_position = lerp(global_position, player_grid_pos * resolution, 0.1)
		grid_pos = player_grid_pos

func get_grid_pos(pos):
	pos.y -= HUD_THICKNESS
	var x = floor(pos.x / resolution.x)
	var y = floor(pos.y / resolution.y)
	return Vector2(x, y)

func get_enemies():
	var enemies = []
	for body in $Area2D.get_overlapping_bodies():
		if body.get("type") == 'ENEMY' && enemies.find(body) == -1:
			enemies.append(body)
	return enemies.size()
