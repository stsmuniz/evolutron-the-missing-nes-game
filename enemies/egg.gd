extends Node2D

const EggEffect = preload("res://enemies/EggEffect.tscn")
const Heart = preload("res://items/health.tscn")
const Key = preload("res://items/key.tscn")

func create_egg_effect():
	var eggEffect = EggEffect.instance()
	get_parent().add_child(eggEffect)
	eggEffect.global_position = global_position


func _on_hurtbox_area_entered(area):
	create_egg_effect()
	queue_free()
	dropItem()


func dropItem():
	randomize()
	var randomResult = randi() % 20

	match randomResult:
		0, 1:
			spawnHeart()
		2:
			spawnKey()
		_:
			pass


func spawnHeart():
	var heart = Heart.instance()
	spawnItem(heart)

func spawnKey():
	var key = Key.instance()
	spawnItem(key)

func spawnItem(item):
	get_parent().add_child(item)
	item.global_position = global_position	
