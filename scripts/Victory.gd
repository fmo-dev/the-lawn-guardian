extends CanvasLayer

var main
var game
var hero
var minutes = 0
var seconds = 0
var score = 2000

func _ready() :
	main = get_tree().get_root().get_node("Main")
	game = get_parent()
	hero = game.get_node("HeroInfo")
	seconds = game.counter
	while seconds >= 60 : 
		minutes += 1
		seconds -= 60
	var minTxt = str(minutes) if minutes > 9 else "0" + str(minutes)
	var secTxt = str(seconds) if seconds > 9 else "0" + str(seconds)
	$TotalTime.text = 'Total Time : ' + minTxt + 'min ' + secTxt + 'sec'
	score -= game.counter
	score -= hero.improvePoint*20
	if score < 0 : score = 0
	$score.text = str(score)
	
func _process(delta): if $Sound.get_playback_position() > 1.6 : $Sound.volume_db -= 1.2

func _on_Menu(): get_tree().change_scene("res://scenes/Main.tscn")


