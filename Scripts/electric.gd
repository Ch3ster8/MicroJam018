extends Area2D
var life
var cantMove = false
var dash = false
@onready var animPlayer = $AnimatedSprite2D/AnimationPlayer
func  _ready():
	animPlayer.play("default")
func _physics_process(delta):
	if life > 0:
		life -= delta
	elif !cantMove:
		queue_free()
	global_position += transform.x * 5
func _on_body_entered(body):
	if body is billy:
		if body.lifeForce > 10:
			body.lifeForce -= 10
		elif body.lifeForce <= 10 and body.lifeForce != 1:
			body.lifeForce = 1
		else:
			body.lifeForce = 0
		body.stunned(1)
		body.movement.canMove = false
		body.canBite = false
		body.biteTimer = body.biteCooldown
		body.screamTimer = body.screamCooldown
		dash = body.dashUnlocked
		body.dashUnlocked = false
		cantMove = true
		await get_tree().create_timer(1).timeout
		if body != null:
			body.movement.canMove = true
			body.dashUnlocked = dash
		queue_free()
