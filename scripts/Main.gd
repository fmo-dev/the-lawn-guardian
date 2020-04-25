extends Node2D

var menu_scene = preload("res://scenes/Menu.tscn")
var arcade_game_scene = preload("res://scenes/ArcadeGame.tscn")
var soundOff
var musicOff
var musicFadingUp = false
var musicFadingDown = false
var volumeLvl = 0
var menu
var arcade_game

func _ready():
	soundOff = AudioServer.is_bus_mute(AudioServer.get_bus_index("Sound"))
	musicOff = AudioServer.is_bus_mute(AudioServer.get_bus_index("Music"))
	menu = menu_scene.instance()
	add_child(menu)
	
func _process(delta):
	if musicFadingUp : musicFadingUp = musicFading(0, 1)
	elif musicFadingDown : musicFadingDown = musicFading(8, -1)

func onGameStart() :
	arcade_game = arcade_game_scene.instance()
	menu.queue_free()
	add_child(arcade_game)

func backToMenu() :
	menu = menu_scene.instance()
	arcade_game.queue_free()
	add_child(menu)


func sound_change(): 
	soundOff = !soundOff
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Sound"), soundOff)

func music_change() :
	musicOff = !musicOff
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), musicOff )
	
func musicChangeVolume(value) : 
	musicFadingUp = value
	musicFadingDown = !value

func musicFading(nb, indic):
	volumeLvl += indic * 0.2
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), volumeLvl)
	return volumeLvl*indic < nb
	
