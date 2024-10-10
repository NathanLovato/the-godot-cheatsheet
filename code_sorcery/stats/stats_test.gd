extends Node2D

const StatsCharacter = preload("stats_character.gd")

var stats: CharacterStats = StatsCharacter.new()

func _ready() -> void:
	stats.print()
	stats.add_modifier("max_health", 100.0)
	stats.add_modifier("magic", 50.0)
	stats.add_modifier("strength", -4.0)
	print("---")
	stats.print()
