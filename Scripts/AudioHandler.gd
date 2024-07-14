extends Node
@export var steamer : PackedScene
@export var animplayer : AnimationPlayer

func play(sound):
	var instant = steamer.instantiate() as AudioStreamPlayer
	instant.stream = load(sound)
	instant.volume_db = -55
	add_child(instant)
	
func change_scene_to_file(file):
	animplayer.play("fade")
	await animplayer.animation_finished
	get_tree().change_scene_to_file(file)
	await get_tree().tree_changed
	await get_tree().physics_frame
	await get_tree().physics_frame
	animplayer.play_backwards("fade")
func change_scene_to_packed(file):
	animplayer.play("fade")
	await animplayer.animation_finished
	get_tree().change_scene_to_packed(file)
	await get_tree().tree_changed
	await get_tree().physics_frame
	await get_tree().physics_frame
	animplayer.play_backwards("fade")
	
func reload_current_scene():
	animplayer.play("fade")
	await animplayer.animation_finished
	get_tree().reload_current_scene()
	await get_tree().tree_changed
	await get_tree().physics_frame
	await get_tree().physics_frame
	animplayer.play_backwards("fade")
func playbutton():
	var instant = steamer.instantiate() as AudioStreamPlayer
	add_child(instant)

func _ready():
	animplayer.play_backwards("fade")
	var buttons = get_tree().get_nodes_in_group("buttons")
	for x in buttons:
		if !x.is_connected("pressed", on_button_pressed):
			x.connect("pressed", on_button_pressed)

func _process(_delta):
	await get_tree().tree_changed
	var buttons = get_tree().get_nodes_in_group("buttons")
	for x in buttons:
		if !x.is_connected("pressed", on_button_pressed):
			x.connect("pressed", on_button_pressed)
	
		
func on_button_pressed():
	var instant = steamer.instantiate() as AudioStreamPlayer
	add_child(instant)
