extends CharacterBody2D
class_name  billy
@export var lifeForce = 100
@export var progress : TextureProgressBar
@export var scoreLabel : Label
@onready var movement = $Movement
@onready var sprite = $BillySprite
@onready var animPlayer = $BillySprite/AnimationPlayer
@onready var blood = $BloodEffect as CPUParticles2D
@export var biteArea : Area2D
@export var biteCooldown = 2
@export var screamLife = 1.5
@export var screamCooldown = 2
@export var scream : PackedScene
@export var checklist : Label
@export var controls : NinePatchRect
@export var controlsLabel : Label
var stunTime = 0
var shake = false
var screamUnlocked = false
var dashUnlocked = false
var dead = false
var score = 0
var canScream = true
var canBite = true
var biteTimer = 0
var screamTimer = 0
func _process(delta):
	if stunTime > 0:
		stunTime -= delta
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
		if InputManager.is_action_just_pressed("dash") and lifeForce > 10 and movement.canDash and dashUnlocked:
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
	elif Input.is_action_just_pressed("scream") and lifeForce > 20 and canScream and screamUnlocked:
		if canScream:
			AudioHandler.play("res://Assets/scream-90747.mp3")
			animPlayer.play("scre")
			lifeForce -= 20
			screamTimer = screamCooldown
			var instant = scream.instantiate() as Node2D
			instant.rotation = rotation
			instant.global_position = global_position + direction * 100
			instant.life = screamLife
			get_tree().root.add_child(instant)
	progress.value = lifeForce
	if lifeForce <= 0 and !dead:
		dead = true
		die()
		
func bite():
	AudioHandler.play("res://Assets/chomp-155392.mp3")
	for body in biteArea.get_overlapping_bodies():
		if !body is billy:
			body.modulate = Color8(255, 0, 0, 155)
			if body.health > lifeForce / 2 + 5:
				body.health -= lifeForce / 2 + 5
			else:
				updateChecklist(body)
				body.die()
				if lifeForce <= 80:
					lifeForce += 20
				else:
					lifeForce = 100
			if get_tree() != null:
				await get_tree().create_timer(0.2).timeout
				if body != null:
					body.modulate = Color8(255, 255, 255, 255)

func die():
	blood.emitting = true
	await blood.finished
	Storage.basicFish = 0
	Storage.pufferfish = 0
	Storage.jellyfish = 0
	Storage.shark = 0
	Storage.score = 0
	AudioHandler.reload_current_scene()
	
func updateChecklist(body):
	var groups = body.get_groups()
	if groups:
		if groups[0] == "basicfish":
			score += 10
			if Storage.basicFish < 10:
				Storage.basicFish += 1
				if Storage.basicFish == 10:
					if !dashUnlocked:
						dashUnlocked = true
						controls.showstuff()
			elif !dashUnlocked:
				dashUnlocked = true
				controls.showstuff()
		elif groups[0] == "pufferfish":
			score += 25
			if Storage.pufferfish < 5:
				Storage.pufferfish += 1
				if Storage.pufferfish == 5:
					if !screamUnlocked:
						screamUnlocked = true
						controls.showstuff()
			elif !screamUnlocked:
				screamUnlocked = true
				controls.showstuff()
		elif groups[0] == "jellyfish":
			score += 50
			if Storage.jellyfish < 2:
				Storage.jellyfish += 1
		elif groups[0] == "shark":
			score += 100
			if Storage.shark < 1:
				Storage.shark += 1
		Storage.score = score
		if Storage.basicFish >= 10 and Storage.pufferfish >= 5 and Storage.jellyfish >= 2 and Storage.shark >= 1:
			AudioHandler.change_scene_to_file("res://Scenes/WinScreen.tscn")
	var locked = {
		"dash" : "",
		"scream" : ""
	}
	if !dashUnlocked:
		locked["dash"] = "🔒"
	if !screamUnlocked:
		locked["scream"] = "🔒"
	controlsLabel.text = "                     Controls:


	WASD:
	   Move
	LeftClick:
	   Attack
	"+locked.dash+"Shift/Space:
	   Dash
	"+locked.scream+"RightClick:
	   Scream"
	checklist.text = "CheckList:
	Snapper: " + str(Storage.basicFish) +"/10
	PufferFish: "  + str(Storage.pufferfish) +"/5
	Jellyfish: "  + str(Storage.jellyfish) +"/2
	Shark: "  + str(Storage.shark) +"/1"
	scoreLabel.text = "Score: " + str(score)
	
	
func stunned(time):
	stunTime = time
	while stunTime > 0:
		await get_tree().create_timer(0.05).timeout
		shake = !shake
		if shake:
			rotation_degrees += 20
		else:
			rotation_degrees -= 20
			
			

