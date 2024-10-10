## This example shows how to create a static signal, even though GDScript does not
## support this in Godot 4.3.
class_name StaticSignalExample

static var player_died: Signal = (func ():
	(StaticSignalExample as RefCounted).add_user_signal("player_died")
	return Signal(StaticSignalExample, "player_died")
).call()
static var is_player_dead := false
