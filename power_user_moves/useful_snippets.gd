extends Node


func _init() -> void:
	file_path_utilities()
	functional_style()


func file_path_utilities() -> void:
	# Get the path to this script's folder.
	var this_folder: String = get_script().resource_path.get_base_dir()
	var this_filename: String = get_script().resource_path.get_file()

	print("This script is in the folder: " + this_folder)
	print("The filename of this script is: " + this_filename)



func functional_style() -> void:
	var color_palette_data := """
  0 122 195 Blue
108  44 218 Purple
196  29  61 Red
"""
	var lines := Array(color_palette_data.split("\n", false))
	var colors: Array[Color]
	colors.assign(lines\
		.map(func(s: String): return s.split(" ", false))\
		.map(func(parts: Array):
			var rgb = parts.slice(0, 3).map(func(s: String): return s.to_int())
			return Color8(rgb[0], rgb[1], rgb[2]))
	)

	for color in colors:
		var color_name: String = lines[colors.find(color)].split(" ")[-1]
		print_rich("[color=%s]%s: %s[/color]" % [color.to_html(false), color_name, color])
