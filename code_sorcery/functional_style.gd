# This script shows an example of using the Array.map and Array.slice methods to parse a Gimp-style color palette file.
# They are pure alternatives to for loops.
extends Node

func _init() -> void:
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
