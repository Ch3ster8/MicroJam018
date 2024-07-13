extends CanvasLayer
@export var startScene : PackedScene
@export var credits : NinePatchRect
@export var settings : NinePatchRect
@export var volumeNum : Label
func _ready():
	credits.hide()
	settings.hide()
func _on_start_pressed():
	get_tree().change_scene_to_packed(startScene)

func _on_quit_pressed():
	get_tree().quit()

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
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif index == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
	volumeNum.text = str(value)
