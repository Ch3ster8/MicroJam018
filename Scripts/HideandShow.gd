extends NinePatchRect
@export var button : Button
var showing
func _on_hide_checklist_pressed():
	if !showing:
		showing = true
		hide()
		button.text = "Show"
	else:
		showing = false
		show()
		button.text = "Hide"

func showstuff():
	showing = false
	show()
	button.text = "Hide"
