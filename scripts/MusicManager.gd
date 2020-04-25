extends Node2D

var time_begin
var time_delay
var time
var loopOn = false
func _ready():
	$Intro.play()
	time_begin = OS.get_ticks_usec()
	time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()

func _process(delta):
	var time = $Intro.get_playback_position() + AudioServer.get_time_since_last_mix()
	# Compensate for output latency.
	time += AudioServer.get_output_latency()
	if time >= $Intro.stream.get_length() && !loopOn : 
		$Music.play()
		loopOn = true
	
