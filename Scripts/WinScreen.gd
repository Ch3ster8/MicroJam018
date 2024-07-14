extends NinePatchRect
@export var label : Label

func _ready():
	label.text = "Snapper: "+str(Storage.basicFish)+"
	Pufferfish: "+str(Storage.pufferfish)+"
	Squid: "+str(Storage.squid)+"
	Jellyfish: "+str(Storage.jellyfish)+"
	Shark: "+str(Storage.shark)+"
	Score: "+str(Storage.score)
func _on_settings_1_pressed():
	Storage.basicFish = 0
	Storage.pufferfish = 0
	Storage.squid = 0
	Storage.jellyfish = 0
	Storage.shark = 0
	Storage.score = 0
	AudioHandler.change_scene_to_file("res://Scenes/main_menu.tscn")
