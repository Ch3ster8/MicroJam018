extends CanvasLayer
@export var mainMenu : String
@export var credits : NinePatchRect
@export var settings : NinePatchRect
@export var volumeNum : Label
@export var windowButton : OptionButton
@export var volumeSlider : HSlider
var paused
func _ready():
	DisplayServer.window_set_mode(Storage.windowMode)
	if Storage.windowMode == 3:
		windowButton.select(0)
	elif Storage.windowMode == 0:
		windowButton.select(1)
	volumeSlider.value = Storage.volume
	AudioServer.set_bus_volume_db(0, linear_to_db(Storage.volume))
	paused = false
	credits.hide()
	settings.hide()
	hide()
func _process(_delta):
	if InputManager.is_action_just_pressed("esc"):
		if !paused:
			paused = true
			get_tree().paused = true
			show()
		else:
			paused = false
			get_tree().paused = false
			credits.hide()
			settings.hide()
			hide()
func _on_start_pressed():
	paused = false
	get_tree().paused = false
	credits.hide()
	settings.hide()
	hide()
	

func _on_quit_pressed():
	Storage.basicFish = 0
	Storage.pufferfish = 0
	Storage.jellyfish = 0
	Storage.shark = 0
	Storage.score = 0
	get_tree().paused = false
	AudioHandler.change_scene_to_file(mainMenu)

func _on_credits_pressed():
	if !credits.visible and !settings.visible:
		credits.show()
	else:
		credits.hide()

func _on_settings_pressed():
	if !settings.visible and !credits.visible:
		settings.show()
	else:
		settings.hide()


func _on_window_button_item_selected(index):
	if index == 0:
		Storage.windowMode = DisplayServer.WINDOW_MODE_FULLSCREEN
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif index == 1:
		Storage.windowMode = DisplayServer.WINDOW_MODE_WINDOWED
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_volume_slider_value_changed(value):
	Storage.volume = value
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
	volumeNum.text = str(value)
