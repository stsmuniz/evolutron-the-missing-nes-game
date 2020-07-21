extends KinematicBody2D

const EnemyDeathEffect = preload("res://enemies/DeathEffect.tscn")

const Spider = preload("res://enemies/spiderling/spiderling.tscn")

signal boss_killed

enum {
	IDLE,
	WANDER,
	CHASE,
	SPAWN
}

var velocity = Vector2.ZERO
var knockback: = Vector2.ZERO
var type = 'ENEMY'
export var max_spiders = 8
var spiders = 0

var state = IDLE

export var acceleration = 200
export var max_speed = 50
export var bash_speed = 50
export var friction = 200
export var wander_target_range = 4

onready var sprite = $Sprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox: = $hurtbox
onready var softCollision: = $SoftCollision
onready var wanderController: = $WanderController
onready var BlinkAnimationPlayer = $AnimationPlayer
onready var visibility = $VisibilityNotifier2D

var active = false

func _ready():
	visibility.connect("screen_entered", self, "_on_VisibilityNotifier2D_screen_entered")
	visibility.connect("screen_exited", self, "_on_VisibilityNotifier2D_screen_exited")
	connect('spider_killed', self, 'update_spider_count')
	set_process(false)
	set_physics_process(false)
	state = pick_random_state([IDLE, WANDER])


func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			$AnimationPlayer.play("idle")
			velocity = Vector2.ZERO
			if wanderController.get_time_left() == 0:
				update_wander([SPAWN, WANDER, CHASE])
		WANDER:
			$AnimationPlayer.play("walk")
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
			accelerate_towards_point(wanderController.target_position, delta)
			if global_position.distance_to(wanderController.target_position) <= wander_target_range:
				update_wander([SPAWN, IDLE, CHASE])
		CHASE:
			$AnimationPlayer.play("walk")
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
				if wanderController.get_time_left() == 0:
					update_wander([IDLE, WANDER, SPAWN])
			else:
				state = WANDER
		SPAWN:
			if spiders <= max_spiders:
				velocity = Vector2.ZERO
				$AnimationPlayer.play("spawn")
				yield($AnimationPlayer, 'animation_finished')
			state = IDLE
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)
	
func accelerate_towards_point(point, delta, speed = max_speed):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * speed, acceleration * delta)
	sprite.flip_h = velocity.x > 0
	
func update_wander(states = [IDLE, WANDER]):
	state = pick_random_state(states)
	wanderController.start_wander_timer(rand_range(1, 3))
	
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 150
	hurtbox.start_invincibility(1.2)
	hurtbox.create_hit_effect()

func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	emit_signal("boss_killed")
	Options.game_sound("boss_death")
	Options.game_music("stop")


func spawnSpider():
		if spiders <= max_spiders:
			var spider = Spider.instance()
			spawnItem(spider)
			spiders += 1

func update_spider_count():
	spiders -= 1


func spawnItem(item):
	get_parent().add_child(item)
	item.global_position = global_position	

func _on_hurtbox_invincibility_started():
	$AnimationPlayer.play("blink")


func _on_hurtbox_invincibility_ended():
	$AnimationPlayer.play("blinkStop")


func _on_VisibilityNotifier2D_screen_entered():
	set_process(true)
	set_physics_process(true)
	Options.choose_music("boss")



func _on_VisibilityNotifier2D_screen_exited():
	set_process(false)
	set_physics_process(false)

