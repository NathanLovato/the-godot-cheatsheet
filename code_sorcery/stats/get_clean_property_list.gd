extends RefCounted

## This function shows how to get and filter the list of properties on a resource.
##
## This technique can be used to get a list of properties that can be saved to a file,
## to create dynamic classes, or to create a custom inspector in a plugin.
##
## This example uses a resource, but the same code can be used with any Object.
static func get_clean_property_list(resource: Resource) -> Array[String]:
	var properties: Array[String] = []
	var ignore := [
		"resource_scene_unique_id",
		"resource_local_to_scene",
		"resource_name",
		"resource_path",
		"script",
	]

	for prop: Dictionary in resource.get_property_list():
		if (
			prop.name.begins_with("_")
			or prop.name[0].capitalize() == prop.name[0]
			or prop.name in ignore
			or prop.name.ends_with(".gd")
		):
			continue
		properties.append(prop.name)

	return properties
