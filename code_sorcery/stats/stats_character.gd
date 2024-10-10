# Represents a Ship's stats, like its hull's health, its speed, etc. The stats are calculated from
# the base_* properties, with modifiers (upgrades) applied to them internally.
# To access the final stats, use the `get_*` functions, or call `get_stat()`
class_name CharacterStats extends Stats

signal health_depleted

@export var max_health := 100.0
@export var strength := 15.0
@export var magic := 12.0
@export var defense := 5.0

var health := max_health: set = set_health


func set_health(value: float) -> void:
	health = clamp(value, 0.0, max_health)
	if is_equal_approx(health, 0.0):
		health_depleted.emit()
	_update("health")


func get_max_health() -> float:
	return get_stat("max_health")


func get_strength() -> float:
	return get_stat("strength")


func get_magic() -> float:
	return get_stat("magic")


func get_defense() -> float:
	return get_stat("defense")
