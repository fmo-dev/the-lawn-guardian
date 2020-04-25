extends CanvasLayer
var main

func _ready() : 
	main = get_parent()
	$lineMusic.visible = main.musicOff
	$lineSound.visible = main.soundOff

func _on_play_click(): main.onGameStart()
	
func _on_Exit(): get_tree().quit()

func _on_music_pressed():
	main.music_change()
	$lineMusic.visible = main.musicOff

func _on_sound_pressed():
	main.sound_change()
	$lineSound.visible = main.soundOff
