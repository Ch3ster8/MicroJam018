extends CharacterBody2D
@onready var movement = $Movement
@onready var sprite = $Sprite
@onready var navigation = $Navigation
@export var biteCooldown = 2
@export var biteAnim : AnimationPlayer
@export var Health = 50
@onready var health = Health
var canBite = true
var biteTimer = 0
var player
func _ready():
	player = get_tree().get_first_node_in_group("billy")
func _process(delta):
	if health <= 0:
		queue_free()
	if biteTimer > 0:
		biteTimer -= delta
		canBite = false
	else:
		canBite = true
func _physics_process(_delta):
	var direction = velocity.normalized()
	navigation.Navigate(player.global_position)
	if direction:
		rotation = lerp_angle(rotation, direction.angle(), 0.1)
		if rotation_degrees > 90 or rotation_degrees < -90:
			sprite.flip_v = true
		else:
			sprite.flip_v = false
		


func _on_bite_area_body_entered(body):
	if body is billy:
		if canBite:
			biteAnim.play("Bite")
			biteTimer = biteCooldown
			if body.lifeForce > 20:
				body.lifeForce -= 20
			elif body.lifeForce <= 20 and body.lifeForce != 1:
				body.lifeForce = 1
			else:
				body.lifeForce = 0
