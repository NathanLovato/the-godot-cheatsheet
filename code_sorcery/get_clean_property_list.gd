extends RefCounted


static func get_clean_property_list(resource: Resource) -> Dictionary:
	var properties := {}
	var ignore := [
		"resource_scene_unique_id",
		"resource_local_to_scene",
		"resource_name",
		"resource_path",
		"script",
	]

	for prop: Dictionary in resource.get_property_list():
		# If the property starts with a capital letter or is a built-in to ignore
		if (
			prop.name[0].capitalize() == prop.name[0]
			or prop.name in ignore
			or prop.name.ends_with(".gd")
		):
			continue
		properties[prop.name.lstrip("_")] = prop.name

	return properties
