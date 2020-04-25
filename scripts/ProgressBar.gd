extends TextureProgress

func start() : 
	value = min_value;
	$Timer.start()

func _on_Timer_timeout():
	var delay = get_parent().get_parent().get_node("shotDelay").wait_time
	value += max_value / (delay / $Timer.wait_time)
	
func stop() : 
	value = max_value
	$Timer.stop()
