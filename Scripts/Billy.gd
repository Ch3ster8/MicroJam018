extends CharacterBody2D
class_name  billy
@export var lifeForce = 100
@export var progress : TextureProgressBar
@export var scoreLabel : Label
@onready var movement = $Movement
@onready var sprite = $BillySprite
@onready var animPlayer = $BillySprite/AnimationPlayer
@export var biteArea : Area2D
@export var biteCooldown = 2
@export var screamLife = 1.5
@export var screamCooldown = 2
@export var scream : PackedScene
var score = 0
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
		if animPlayer.current_animation != "biting" and animPlayer.current_animation != "scre":
			animPlayer.play("swim")
		rotation = lerp_angle(rotation, direction.angle(), 0.1)
		if InputManager.is_action_just_pressed("dash") and lifeForce > 10 and movement.canDash:
			lifeForce -= 10
			movement.Dash(direction)
		if rotation_degrees > 90 or rotation_degrees < -90:
			sprite.flip_v = true
		else:
			sprite.flip_v = false
	elif animPlayer.current_animation != "biting" and animPlayer.current_animation != "scre":
		animPlayer.stop()
	movement.Move(self)
	if Input.is_action_just_pressed("attack"):
		if canBite:
			animPlayer.play("biting")
			biteTimer = biteCooldown
	if Input.is_action_just_pressed("scream") and lifeForce > 20 and canScream:
		if canScream:
			animPlayer.play("scre")
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
		
func bite():
	for body in biteArea.get_overlapping_bodies():
		body.modulate = Color8(255, 0, 0, 155)
		if body.health > lifeForce / 2 + 5:
			body.health -= lifeForce / 2 + 5
		else:
			score += 10
			scoreLabel.text = "Score: " + str(score)
			body.queue_free()
			if lifeForce <= 80:
				lifeForce += 20
			else:
				lifeForce = 100
		await get_tree().create_timer(0.2).timeout
		if body != null:
			body.modulate = Color8(255, 255, 255, 255)
