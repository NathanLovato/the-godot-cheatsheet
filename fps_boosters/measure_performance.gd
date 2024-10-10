extends Node

var _performance_test_results := {}

func _ready():
	# NOTE: there's an overhead using measure_performance_function(), so the
	# results are just an approximation.
	print("Measuring performance of Vector2.length() vs. Vector2.length_squared()...")

	# Methods are callables, so we can pass them as arguments.
	var length_result := measure_performance_function(Vector2(1, 1).length)
	var length_squared_result := measure_performance_function(Vector2(1, 1).length_squared)

	print("Vector2.length() took an average of %.2f ms to execute." % length_result)
	print("Vector2.length_squared() took an average of %.2f ms to execute." % length_squared_result)
	print("Vector2.length() was %.2f times slower than Vector2.length_squared()." % (length_result / length_squared_result))


func measure_performance_function(target_function: Callable, call_count := 10_000, iterations := 5) -> float:
	var durations := []

	for i in iterations:
		var start_time := Time.get_ticks_usec()
		for j in call_count:
			target_function.call()
		var end_time := Time.get_ticks_usec()
		var duration_ms := (end_time - start_time) / 1000.0
		durations.append(duration_ms)

	var average_duration_ms: float = (func ():
		var output := 0.0
		for duration in durations:
			output += duration
		return output / iterations
	).call()
	return average_duration_ms
