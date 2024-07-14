extends Area2D
var life
var cantMove = false
var bodies = []
@onready var animPlayer = $AnimatedSprite2D/AnimationPlayer
func  _ready():
	animPlayer.play("default")
func _physics_process(delta):
	if life > 0:
		life -= delta
	elif !cantMove:
		queue_free()
	global_position += transform.x * 15
func _on_body_entered(body):
	body.stunned(2.3)
	body.movement.canMove = false
	body.canBite = false
	body.biteTimer = body.biteCooldown
	bodies.append(body)
	cantMove = true
	await get_tree().create_timer(2.3).timeout
	for bodys in bodies:
		if bodys != null:
			bodys.movement.canMove = true
	queue_free()
