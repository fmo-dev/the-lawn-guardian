extends Node2D

var counter = 0
var main
var stage_scene = preload("res://scenes/ArcadeStage.tscn")
var stage

func onEverySecond(): 
	counter += 1;
	var minutes = floor(counter / 60)
	var seconds = counter % 60
	var minutesStr = '0'  +  str(minutes) if minutes < 10 else str(minutes)
	var secondsStr = '0'  +  str(seconds) if seconds < 10 else str(seconds)
	$ColorRect/timer.text = minutesStr + ':' + secondsStr


func _ready() : 
	var stage = stage_scene.instance()
	stage.victoryCondition = 200
	add_child(stage)
	main = get_parent()
	$lineMusic.visible = main.musicOff
	$lineSound.visible = main.soundOff

func _on_music_pressed():
	main.music_change()
	$lineMusic.visible = main.musicOff

func _on_sound_pressed():
	main.sound_change()
	$lineSound.visible = main.soundOff
