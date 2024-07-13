extends CharacterBody2D
class_name  billy
@export var lifeForce = 100
@export var progress : TextureProgressBar
@onready var movement = $Movement
@onready var sprite = $BillySprite
@onready var animPlayer = $BillySprite/AnimationPlayer
@export var biteArea : Area2D
@export var biteCooldown = 2
@export var biteAnim : AnimationPlayer
@export var screamLife = 1.5
@export var screamCooldown = 2
@export var scream : PackedScene
var canScream = true
var canBite = true
var biteTimer = 0
var screamTimer = 0
func _process(delta):
	if biteTimer > 0:
		biteTimer -= delta
		canBite = false
	else:
		canBite = true
	if screamTimer > 0:
		screamTimer -= delta
		canScream = false
	else:
		canScream = true
func _physics_process(_delta):
	var direction = Vector2(InputManager.get_axis("left","right"), InputManager.get_axis("up","down"))
	movement.MoveTowards(direction)
	if direction:
		rotation = lerp_angle(rotation, direction.angle(), 0.1)
		if InputManager.is_action_just_pressed("dash") and lifeForce > 20 and movement.canDash:
			lifeForce -= 20
			movement.Dash(direction)
		if rotation_degrees > 90 or rotation_degrees < -90:
			sprite.flip_v = true
		else:
			sprite.flip_v = false
	movement.Move(self)
	if Input.is_action_just_pressed("attack"):
		if canBite:
			biteAnim.play("Bite")
			animPlayer.play("default")
			biteTimer = biteCooldown
			if biteArea.has_overlapping_bodies():
				biteArea.get_overlapping_bodies()[0].health -= 25
				if lifeForce <= 80:
					lifeForce += 20
	if Input.is_action_just_pressed("scream") and lifeForce > 20 and canScream:
		lifeForce -= 20
		screamTimer = screamCooldown
		var instant = scream.instantiate() as Node2D
		instant.rotation = rotation
		instant.global_position = global_position + direction * 100
		instant.life = screamLife
		get_tree().root.add_child(instant)
			
	progress.value = lifeForce
	if lifeForce <= 0:
		await get_tree().create_timer(0.2).timeout
		get_tree().reload_current_scene()
		
