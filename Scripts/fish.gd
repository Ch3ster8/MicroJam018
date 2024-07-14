extends CharacterBody2D
@onready var movement = $Movement
@onready var sprite = $Sprite
@onready var navigation = $Navigation
@export var biteCooldown = 2
@export var biteAnim : AnimationPlayer
@export var Health = 50
@onready var health = Health
@onready var blood = $BloodEffect
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
		rotation = lerp_angle(rotation, direction.angle(), 0.1)
		if rotation_degrees > 90 or rotation_degrees < -90:
			sprite.flip_v = true
		else:
			sprite.flip_v = false
	elif biteAnim.current_animation != "Bite":
		biteAnim.stop()
		


func _on_bite_area_body_entered(body):
	AudioHandler.play("res://Assets/chomp-155392.mp3")
	if body is billy:
		if biteAnim.current_animation != "Bite":
			if canBite:
				body.modulate = Color8(255, 0, 0, 155)
				waiting = body
				biteAnim.play("Bite")
				biteTimer = biteCooldown
				if body.lifeForce > 20:
					body.lifeForce -= 20
				elif body.lifeForce <= 20 and body.lifeForce != 1:
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
