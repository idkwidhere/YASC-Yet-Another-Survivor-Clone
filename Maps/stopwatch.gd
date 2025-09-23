extends Label
class_name Stopwatch

var time: float = 0.0
var stopped = false

func _process(delta: float) -> void:
	if stopped:
		return
	time += delta
	text = time_to_string()

func reset_timer() -> void:
	time = 0.0
	
func time_to_string() -> String:
	var secs = fmod(time, 60)
	var mins = time / 60
	var format_string = "%02d : %02d" 
	var return_string = format_string % [mins, secs]
	return return_string
