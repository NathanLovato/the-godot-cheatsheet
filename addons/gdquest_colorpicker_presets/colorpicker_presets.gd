@tool
extends EditorPlugin


func _enter_tree() -> void:
	var presets_path: String = get_script().resource_path.get_base_dir().path_join('presets.gpl')
	var presets_file := FileAccess.open(presets_path, FileAccess.READ)

	if FileAccess.get_open_error() == OK:
		var presets_raw := presets_file.get_as_text(true).strip_edges().split("\n")
		presets_file.close()
		presets_raw = presets_raw.slice(presets_raw.find("#") + 1)
		var presets := Array(presets_raw).map(
			func(string: String):
				var rgb := (Array(string.strip_edges().split(" ").slice(0, -1))
					.filter(func(string: String): return not string.is_empty())
					.map(func(string: String): return string.to_int())
				)
				return Color8(rgb[0], rgb[1], rgb[2])
		)
		get_editor_interface().get_editor_settings().set_project_metadata(
			"color_picker", "presets", presets
		)
