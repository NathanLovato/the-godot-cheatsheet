extends Node

func _ready() -> void:
	assigning_to_typed_arrays()


func assigning_to_typed_arrays() -> void:
	# You cannot assign an untyped array to a typed array.
	# You need to use the `Array.assign()` method to cast the array.
	var numbers := [1, 2, 3]
	var numbers_typed: Array[int]
	numbers_typed.assign(numbers)

	# This causes issues when you write strongly typed code and use methods like Array.map() or Array.filter().
	var characters := [
		{"name": "Gobot", "level": 5},
		{"name": "Sophia", "level": 3},
	]
	var character_strings: Array[String]
	character_strings.assign(characters.map(func(char: Dictionary):
		return "%s is level %d" % [char["name"], char["level"]]
	))
	print("\n"".join(character_strings))
