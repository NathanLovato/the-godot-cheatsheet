extends Node

func _init() -> void:
	var iterations := 10_000
	var runs := 20
	var total_time_length := 0.0
	var total_time_length_squared := 0.0

	var vector := Vector2(1, 1)
	for current_run in range(runs):
		var start_time := Time.get_ticks_usec()
		for i in range(iterations):
			vector.length()
		var end_time = Time.get_ticks_usec()
		total_time_length += (end_time - start_time) / 1000.0

		start_time = Time.get_ticks_usec()
		for i in range(iterations):
			vector.length_squared()
		end_time = Time.get_ticks_usec()
		total_time_length_squared += (end_time - start_time) / 1000.0

	var average_time_length := total_time_length / runs
	var average_time_length_squared := total_time_length_squared / runs

	print("Average time for length(): %.2f ms" % average_time_length)
	print("Average time for length_squared(): %.2f ms" % average_time_length_squared)
	print("length() is %.2f times slower than length_squared()" % (average_time_length / average_time_length_squared))
