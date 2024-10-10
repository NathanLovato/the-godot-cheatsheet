## Provides functions to change and reset input mappings.
##
## This script provides functions to remap input actions to new input events
## and reset all input mappings to their default values.
##
## It stores the default input mappings for all input actions in the project
## at the time the script is loaded.
##
## It assumes that a given input is mapped to a single input event for demo purposes.
extends RefCounted

## Stores the default input mappings for all input actions in the project.
## Contains pairs of ActionName: StringName, InputEvent[]
##
## This property is automatically populated when the script is loaded, so,
## it assumes that all input actions are already defined in the InputMap.
## It is used to reset all input mappings to their default values.
var _default_inputs: Dictionary = (func ():
	var output := {}
	for action in InputMap.get_actions():
		# We skip all predefined Godot actions. You may want to change this depending
		# on your project.
		if action.begins_with("ui_"):
			continue
		output[action] = InputMap.action_get_events(action)
	return output
).call()


## Remaps an action to a new input event.
func remap_action(action: String, event: InputEvent) -> void:
	if not InputMap.has_action(action):
		printerr("Error: Action '%s' does not exist. Cannot remap the action." % action)
		return

	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event)


## Resets all input mappings to their default values.
func reset_all_actions_to_default() -> void:
	for action in InputMap.get_actions():
		InputMap.action_erase_events(action)

	for action in _default_inputs:
		for event in _default_inputs[action]:
			InputMap.action_add_event(action, event)


## Resets a single action to its default value.
## You can use this in an input menu to reset a single action.
func reset_action_to_default(action: String) -> void:
	if not InputMap.has_action(action):
		printerr("Error: Action '%s' does not exist. Cannot reset the action to default mappings." % action)
		return

	InputMap.action_erase_events(action)
	for event in _default_inputs[action]:
		InputMap.action_add_event(action, event)
