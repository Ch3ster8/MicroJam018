extends CharacterBody2D
@onready var movement = $Movement
@onready var sprite = $Sprite
@onready var navigation = $Navigation
@export var biteCooldown = 2
@export var biteAnim : AnimationPlayer
@export var Health = 50
@onready var health = Health
@onready var blood = $BloodEffect
@export var bitearea : Area2D
@export var electric : PackedScene
@export var electricLife = 1
var fakerotation
var waiting
var shake = false
var stunTime =0
var canBite = true
var biteTimer = 0
var player
func _ready():
	player = get_tree().get_first_node_in_group("billy")
func _process(delta):
	if stunTime > 0:
		stunTime -= delta
	if health <= 0:
		die()
	if biteTimer > 0:
		biteTimer -= delta
		canBite = false
	else:
		canBite = true
func _physics_process(_delta):
	var direction = velocity.normalized()
	navigation.Navigate(player.global_position)
	if direction:
		if biteAnim.current_animation != "Bite":
			biteAnim.play("swim")
		fakerotation = lerp_angle(rotation, direction.angle(), 0.1) as float
		var fake = rad_to_deg(fakerotation)
		if fake > 90 or fake < -90:
			sprite.flip_v = true
		else:
			sprite.flip_v = false
	elif biteAnim.current_animation != "Bite":
		biteAnim.stop()
	for body in bitearea.get_overlapping_bodies():
		if body is billy:
			if biteAnim.current_animation != "bite":
				if canBite:
					AudioHandler.play("res://Assets/chomp-155392.mp3")
					biteAnim.play("Bite")
					biteTimer = biteCooldown
					var instant = electric.instantiate() as Node2D
					instant.rotation = get_angle_to(player.global_position)
					instant.global_position = global_position
					instant.life = electricLife
					get_tree().root.add_child(instant)		

func checkfirstbite():
	if bitearea.has_overlapping_bodies():
		var bodies = bitearea.get_overlapping_bodies()
		for body in bodies:
			if body is billy:
				if biteAnim.current_animation != "bite":
					if canBite:
						AudioHandler.play("res://Assets/chomp-155392.mp3")
						body.modulate = Color8(255, 0, 0, 155)
						waiting = body
						biteAnim.play("Bite")
						biteTimer = biteCooldown
						if body.lifeForce > 25:
							body.lifeForce -= 25
						elif body.lifeForce <= 25 and body.lifeForce != 1:
							body.lifeForce = 1
						else:
							body.lifeForce = 0	
						await get_tree().create_timer(0.2).timeout
						if body != null:
							body.modulate = Color8(255, 255, 255, 255)
							waiting = null
func checkbite():
	if bitearea.has_overlapping_bodies():
		var bodies = bitearea.get_overlapping_bodies()
		for body in bodies:
			if body is billy:
				body.modulate = Color8(255, 0, 0, 155)
				waiting = body
				if body.lifeForce > 5:
					body.lifeForce -= 5
				elif body.lifeForce <= 5 and body.lifeForce != 1:
					body.lifeForce = 1
				else:
					body.lifeForce = 0
				await get_tree().create_timer(0.2).timeout
				if body != null:
					body.modulate = Color8(255, 255, 255, 255)
					waiting = null
func die():
	blood.emitting = true
	await blood.finished
	if waiting != null:
		waiting.modulate = Color8(255, 255, 255, 255)
	queue_free()
	
func stunned(time):
	stunTime = time
	while stunTime > 0:
		await get_tree().create_timer(0.05).timeout
		shake = !shake
		if shake:
			rotation_degrees += 20
		else:
			rotation_degrees -= 20
