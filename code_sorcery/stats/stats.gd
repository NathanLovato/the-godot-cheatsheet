## Virtual base class for stats (health, speed...) that support upgrades.
##
## Each stat should be a floating point value, and we recommend to make them private properties, as
## they should be read-only. To get a stat's calculated value, with modifiers, see [get_stat()].
class_name Stats extends Resource

## Emitted when a stat's value changes.
signal stat_changed(stat: String, old_value, new_value)

## Stores a cached array of property names that are stats as strings, that we use to find and
## calculate the stats with upgrades from the base stats.
var _stats_list: Array[String] = preload("get_clean_property_list.gd").get_clean_property_list(self)

## This is a list of modifiers for each property in `_stats_list`. A modifier is a dict that
## requires a key named `value`. The value of a modifier can be positive or negative.
var _modifiers := {}
# Stores the cached values for the computed stats
var _cache := {}


## Initializes the keys in the modifiers dict, ensuring they all exist, without going through the
## property's setter.
func _init() -> void:
	for stat in _stats_list:
		_modifiers[stat] = []
		_cache[stat] = 0.0
	_update_all()

func get_stat_names() -> Array[String]:
	return _stats_list.duplicate()

## Get the final value of a stat, with all modifiers applied to it.
func get_stat(stat_name := "") -> float:
	assert(stat_name in _stats_list)
	return _cache[stat_name]


## Adds a modifier to the stat corresponding to `stat_name` and returns the new modifier's id.
func add_modifier(stat_name: String, modifier: float) -> int:
	assert(stat_name in _stats_list)
	_modifiers[stat_name].append(modifier)
	_update(stat_name)
	return len(_modifiers)


## Removes a modifier from the stat corresponding to `stat_name`.
func remove_modifier(stat_name: String, id: int) -> void:
	assert(stat_name in _stats_list)
	_modifiers[stat_name].erase(id)
	_update(stat_name)


## Removes the last modifier applied the stat corresponding to `stat_name`.
func pop_modifier(stat_name: String) -> void:
	assert(stat_name in _stats_list)
	_modifiers[stat_name].pop_back()
	_update(stat_name)


## Remove all modifiers and recalculate stats.
func reset() -> void:
	_modifiers = {}
	_update_all()


## Prints all the stats and their final value to the Output panel.
func print() -> void:
	var max_stat_name_length := 0
	for stat_name in _stats_list:
		max_stat_name_length = max(max_stat_name_length, stat_name.length())

	for stat_name in _stats_list:
		var padding = " ".repeat(max_stat_name_length - stat_name.length())
		print("%s:%s %s" % [stat_name, padding, get_stat(stat_name)])


## Calculates the final value of a single stat: its base value with all modifiers applied.
func _update(stat: String = "") -> void:
	var value_start: float = get(stat)
	var value = value_start
	for modifier in _modifiers[stat]:
		value += modifier
	_cache[stat] = value
	if not is_equal_approx(value, value_start):
		stat_changed.emit(stat, value_start, value)


## Recalculates every stat from the base stats, with modifiers.
func _update_all() -> void:
	for stat in _stats_list:
		_update(stat)
