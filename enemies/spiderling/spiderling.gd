extends KinematicBody2D

const EnemyDeathEffect = preload("res://enemies/DeathEffect.tscn")

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockback: = Vector2.ZERO
var type = 'ENEMY'

var state = IDLE

export var acceleration = 200
export var max_speed = 50
export var friction = 200
export var wander_target_range = 4

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox: = $hurtbox
onready var softCollision: = $SoftCollision
onready var wanderController: = $WanderController
onready var BlinkAnimationPlayer = $BlinkAnimationPlayer

func _ready():
	state = pick_random_state([IDLE, WANDER, CHASE])

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
			accelerate_towards_point(wanderController.target_position, delta)
			if global_position.distance_to(wanderController.target_position) <= wander_target_range:
				update_wander()
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)

			else:
				state = IDLE

	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)
	
func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	sprite.flip_h = velocity.x > 0
	
func update_wander():
	state = pick_random_state([IDLE, WANDER])
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
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)

func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position


func _on_hurtbox_invincibility_started():
	BlinkAnimationPlayer.play("Start")


func _on_hurtbox_invincibility_ended():
	BlinkAnimationPlayer.play("Stop")
