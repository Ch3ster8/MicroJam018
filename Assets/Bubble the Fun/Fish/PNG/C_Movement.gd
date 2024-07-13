extends Node
var velocity : Vector2
var dashVelocity : Vector2
@export var speed = 80.0
@export var acceleration = 15.0
@export var deceleration = 10.0
@export var dashForce = 200.0
@export var dashTime = 0.2
@export var canMove = true
var isDashing = false
var dashTimer : float

#Ticks the dashTimer down if it's above 0;
#if its below 0 then decelerate the dash
func _physics_process(delta):
		if (dashTimer > 0):
			dashTimer -= delta
		elif isDashing == true:
			isDashing = false
			DecelerateDash()
		else:
			DecelerateDash()
		if !canMove:
			Decelerate()
#Decelerates the velocity by moving it towards 0 by the deceleration time;
#also makes sure the velocity is capped at the speed
func Decelerate():
	if (velocity.x > speed):
		velocity.x = speed
	if (velocity.y > speed):
		velocity.y = speed
	velocity = velocity.normalized()
	velocity.x = move_toward(velocity.x, 0, deceleration)
	velocity.y = move_toward(velocity.y, 0, deceleration)

#Decelerates the dashVelocity to 0 by the deceleration time
func DecelerateDash():
	dashVelocity.x = move_toward(dashVelocity.x, 0, deceleration)
	dashVelocity.y = move_toward(dashVelocity.y, 0, deceleration)

#Takes an input of a direction and changes this scripts velocity;
#to move towards the inputed direction by the acceleration time.
#If there is no inputed direction then the velocity will Decelerate
func MoveTowards(direction : Vector2):
	if direction != Vector2.ZERO && canMove:
		direction = direction.normalized()
		velocity.x = move_toward(velocity.x, direction.x*speed, acceleration)
		velocity.y = move_toward(velocity.y, direction.y*speed, acceleration)
	else:
		Decelerate()
		
#Sets the velocity to the direction times the speed times the dashForce
func Dash(direction : Vector2):
	if canMove && direction != Vector2.ZERO:
		direction = direction.normalized()
		dashVelocity = direction*dashForce
		isDashing = true
		dashTimer = dashTime
func Knockback(direction : Vector2, strength : float):
	velocity += direction * strength
		
#Moves the body towards this scripts velocity var and;
#if dashing then it will use the dashVelocity instead
func Move(body : CharacterBody2D):
	if (!isDashing):
		body.velocity = velocity
	else:
		body.velocity = dashVelocity
	body.move_and_slide()
#Returns the data needed for saving in a dictionary
func get_data():
	var data = {
		"isDashing" : isDashing
	}
	return data 
#Called after loading Json, sets canMove to true
func Load():
	canMove = true
