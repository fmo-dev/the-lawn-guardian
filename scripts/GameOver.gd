extends CanvasLayer

signal tryAgain
var main 
func _ready(): 
	main = get_tree().get_root().get_node("Main")
	main.musicChangeVolume(false)

func _on_TryAgain(): 
	queue_free()
	emit_signal("tryAgain")
	main.musicChangeVolume(true)
	
func _on_Menu(): 
	main.musicChangeVolume(true)
	main.backToMenu()
