extends Node
var actions = {}
func _ready():
	for action in InputMap.get_actions():
		var action_data = {
			"dragging" : false,
			"pressed" : false,
		}
		actions[action] = action_data
func _unhandled_input(event):
	for action in InputMap.get_actions():
		if event.is_action(action):
			if event.is_pressed():
				if actions.has(action):
					if !actions[action]["pressed"] and !actions[action]["dragging"]:
						var action_data = {
							"dragging" : true,
							"pressed" : true,
						}
						actions[action] = action_data
					else:
						var action_data = {
							"dragging" : true,
							"pressed" : false,
						}
						actions[action] = action_data
			else:
				var action_data = {
					"dragging" : false,
					"pressed" : false,
				}
				actions[action] = action_data

func is_action_just_pressed(action):
	if actions.has(action):
		if actions[action]["pressed"]:
			var action_data = {
				"dragging" : true,
				"pressed" : false,
			}
			actions[action] = action_data
			return true
		else:
			return false
	
func is_action_pressed(action):
	if actions.has(action):
		return actions[action]["dragging"]

func get_axis(negX, posX):
	if actions.has(negX) and actions.has(posX):
		if actions[negX]["dragging"] or actions[posX]["dragging"]:
			return Input.get_action_strength(posX) - Input.get_action_strength(negX)
		else:
			return 0
