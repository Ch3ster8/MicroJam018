extends Area2D
@export var anglerFish : PackedScene
@export var clownFish : PackedScene
@onready var fish := [anglerFish, clownFish]

func _ready():
	for x in 50:
		var instant = fish.pick_random().instantiate()
		instant.position = get_placement_pos(global_position, get_child(0).get_shape().size, Vector2(50, 50), true)
		add_child(instant)
func get_placement_pos(area_pos: Vector2, area_size: Vector2, obj_size: Vector2, including_edges: bool = false) -> Vector2:
	assert(obj_size.x < area_size.x)
	assert(obj_size.y < area_size.y)

	var x := int(area_pos.x)
	var y := int(area_pos.y)
	var w := int(area_size.x)
	var h := int(area_size.y)

	var max_x = area_size.x - obj_size.x
	var max_y = area_size.y - obj_size.y

	if including_edges:
		w += 1
		h += 1
	else:
		x += 1
		y += 1
		w -= 1
		h -= 1
		max_x -= 1
		max_y -= 1

	randomize()
	var random_x = x + (randi() % w)
	var random_y = y + (randi() % h)
	var random_pos := Vector2(random_x, random_y)

	random_pos.x = min(random_pos.x, max_x)
	random_pos.y = min(random_pos.y, max_y)
	return random_pos
