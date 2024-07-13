extends Area2D
@onready var navAgent = $NavigationAgent2D
@export var user : CharacterBody2D
@export var c_movementpath : NodePath
@export var steering_power = 0.8
var cooldown = 0.5
var timer = 0
var lastDir
var firstPosition
var c_movement

#Each cardinal direction
var directions = [Vector2(0,1), Vector2(1,1), Vector2(1,0), Vector2(1,-1), Vector2(0,-1), Vector2(-1,-1), Vector2(-1,0), Vector2(-1,1)]
#Empty arrays
var raycasts = []
var interests = [Vector2(0,0), Vector2(0,0), Vector2(0,0), Vector2(0,0), Vector2(0,0), Vector2(0,0), Vector2(0,0), Vector2(0,0)]
var dangers = [0,0,0,0,0,0,0,0]
var direction 

#Add all the raycasts under this node to a list
func _ready():
	c_movement = get_node(c_movementpath)
	for x in get_children():
		if x is RayCast2D:
			raycasts.append(x)
	firstPosition = global_position
func _process(delta):
	if timer > 0:
		timer -= delta
func Navigate(interest : Vector2):
	if has_overlapping_bodies():
		#Getting the direction to the player
		navAgent.target_position = interest
		direction = navAgent.get_next_path_position() - global_position
		direction = direction.normalized()
		#Getting the dot value of each direction, the largest value corresponds to the value closest to the direction
		for x in directions.size():
			interests[x] = directions[x].dot(direction)
		#Looping through the raycasts to see if we are near anything and adding the value 5 in the direction we are colliding
		#and the value 2 on the directions closest to the colliding side
		dangers = [0,0,0,0,0,0,0,0]
		for x in raycasts.size():
			if raycasts[x].is_colliding():
				dangers[x] = 6
				'''if x-1 < dangers.size():
					if dangers[x-1] < 6:
						dangers[x-1] = 3
				if x+1 < dangers.size():
					if dangers[x+1] < 6:
						dangers[x+1] = 3'''
		#looping through the interests to minus the dangers, the largest value after this step is the direction we will move in
		for x in interests.size():
			interests[x] -= dangers[x]
			if interests[x] < 0:
				interests[x] = 0
		#Getting the final direction
		var finalDirection = Vector2.ZERO
		for x in interests.size():
			finalDirection += directions[x] * interests[x]
		#Making the final direction rounded by the steering power variable
		var steering_direction = finalDirection - c_movement.velocity
		finalDirection = c_movement.velocity + steering_direction * steering_power
		#Lastly moving the enemy using the movement controller
		c_movement.MoveTowards(finalDirection.normalized())
		c_movement.Move(user)
	else:
		for x in directions.size():
			interests[x] = directions[x].dot(randomDir())
		#Looping through the raycasts to see if we are near anything and adding the value 5 in the direction we are colliding
		#and the value 2 on the directions closest to the colliding side
		dangers = [0,0,0,0,0,0,0,0]
		for x in raycasts.size():
			if raycasts[x].is_colliding():
				dangers[x] = 6
		#looping through the interests to minus the dangers, the largest value after this step is the direction we will move in
		for x in interests.size():
			interests[x] -= dangers[x]
			if interests[x] < 0:
				interests[x] = 0
		#Getting the final direction
		var finalDirection = Vector2.ZERO
		for x in interests.size():
			finalDirection += directions[x] * interests[x]
		#Making the final direction rounded by the steering power variable
		var steering_direction = finalDirection - c_movement.velocity
		finalDirection = c_movement.velocity + steering_direction * steering_power
		#Lastly moving the enemy using the movement controller
		c_movement.MoveTowards(finalDirection.normalized())
		c_movement.Move(user)

func randomDir():
	if timer <= 0:
		timer = cooldown
		lastDir = Vector2(randi_range(-1, 1), randi_range(-1, 1))
		if global_position.distance_to(firstPosition) > 50:
			return global_position.direction_to(firstPosition)
		else:
			return lastDir
	else:
		return lastDir
