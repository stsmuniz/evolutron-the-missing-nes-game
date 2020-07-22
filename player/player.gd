extends KinematicBody2D

signal key_changed(value)

export (PackedScene) var Bullet

var stats = PlayerStats
var keys = 0 setget _set_keys
var max_bullets = 1

onready var animationTree: AnimationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox: = $hitboxPivot/Swordhitbox
onready var hurtbox = $hurtbox
onready var BlinkAnimationPlayer = $BlinkAnimationPlayer

var speed: int = 75
var input_vector = Vector2.ZERO

enum {
	IDLE,
	ATTACK,
	ITEM
}

var state = IDLE
var velocity: Vector2 = Vector2.ZERO

func _unhandled_input(event):
	input_vector = get_input_vector()
	if Input.is_action_just_pressed("a"):
		state = ATTACK
	if Input.is_action_just_pressed("b"):
		if PlayerStats.powerup_shot == true:
			state = ITEM

func _ready():
	randomize()
	stats.connect("no_health", self, "game_over")
	animationTree.active = true
	swordHitbox.knockback_vector = input_vector

func _physics_process(delta):
	match state:
		IDLE:
			move_state(delta)
		ATTACK:
			attack_state()
		ITEM:
			range_state()
			

func game_over():
	queue_free()
	SceneChanger.change_scene("res://screens_menus/GameOver.tscn", 0.5)


func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	return input_vector


func move_state(delta):
	animationState.travel("idle")
	if input_vector != Vector2.ZERO:
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/idle/blend_position", input_vector)
		animationTree.set("parameters/attack/blend_position", input_vector)
		animationTree.set("parameters/range/blend_position", input_vector)
		velocity = input_vector * speed
	else:
		velocity = Vector2.ZERO
	move()
	
func attack_state():
	animationState.travel("attack")
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/idle/blend_position", input_vector)
		animationTree.set("parameters/range/blend_position", input_vector)
		velocity = input_vector * speed
	else:
		velocity = Vector2.ZERO
	move()

func range_state():
	animationState.travel("range")
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/idle/blend_position", input_vector)
		animationTree.set("parameters/attack/blend_position", input_vector)
		velocity = input_vector * speed
	else:
		velocity = Vector2.ZERO
	move()
	
func shoot():
	var bulletPool: = []
	var nut = Bullet.instance()
	if bulletPool.size() < max_bullets:
		bulletPool.append(nut)
	else:
		nut.queue_free()
	
	for b in bulletPool:
		owner.add_child(b)
		b.transform = $hitboxPivot/BulletPosition2D.global_transform
	
func move():
	velocity = move_and_slide(velocity)
	
func atack_animation_finished():
	state = IDLE


func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(1.5)
	hurtbox.create_hit_effect()


func _set_keys(qty):
	keys = qty
	keys = min(keys, 9)
	emit_signal("key_changed", keys)


func _on_hurtbox_invincibility_started():
	BlinkAnimationPlayer.play("Start")


func _on_hurtbox_invincibility_ended():
	BlinkAnimationPlayer.play("Stop")
	
func play_sfx(name):
	Options.game_sound(name)
