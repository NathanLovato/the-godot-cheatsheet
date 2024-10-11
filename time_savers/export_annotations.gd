extends Node

# This adds a heading to the inspector under which following properties are listed.
# Those are the same headings used for node types in the editor.
@export_category("Animation")

# This annotation displays angles as degrees in the inspector but stores them as radians.
@export_range(-PI, PI, 0.001, "radians_as_degrees") var angle := 0.0
# This annotation creates a limited range but allows the user to enter values greater than the maximum manually.
# The "suffix:" argument adds a suffix to the label in the inspector.
@export_range(0.01, 2.0, 0.01, "or_greater", "suffix:s") var duration := 1.0

# A group is a folded section in the inspector. It groups the following properties together.
@export_group("Colors")
@export var color_1 := Color(1, 0, 0, 1)
@export var color_2 := Color(0, 1, 0, 1)
