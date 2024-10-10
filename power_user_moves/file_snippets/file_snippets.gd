extends Node


func _init() -> void:
	file_path_utilities()


func file_path_utilities() -> void:
	# Get the path to this script's folder.
	var this_folder: String = get_script().resource_path.get_base_dir()
	var this_filename: String = get_script().resource_path.get_file()

	print("This script is in the folder: " + this_folder)
	print("The filename of this script is: " + this_filename)
