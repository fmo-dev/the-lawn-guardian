extends Node2D

var barbarian_scene = preload("res://scenes/Barbarian.tscn")
var gameOver_scene = preload("res://scenes/GameOver.tscn")
var victory_scene = preload("res://scenes/Victory.tscn")

var gameOver
var hero
var gain
var speed
var initPos

var gainMult
var addDumb
var killCount 
var victoryCondition
var barbarTotal
var barbarCurrent
var immune

func _ready(): 
	randomize()
	immune = true
	initPos = $Player.position
	hero = get_parent().get_node("HeroInfo")
	init()

func init():
	for child in get_children(): if child.is_in_group("ennemies") : child.queue_free()	
	$StageTimer.start()
	barbarTotal = 0
	barbarCurrent = 0
	killCount = 0
	addDumb = 10
	gain = 15 if hero.goldDigger else 10
	speed = 300
	gainMult = 1
	$DumbTimer.start()
	$Player.invincible = false
	$Player.get_node("Skin").modulate = Color(1, 1, 1, 1) 
	$score.text = str(victoryCondition-killCount)
	$Player.get_node("Skin").visible = true
	$Player.position = initPos
	$Player.speed = hero.speed
	$Player.get_node("shotDelay").wait_time = hero.arrowDelay
	$Player.arrowPers = hero.arrowPers
	$Player.life = hero.life
	$life.text = str($Player.life)
	gameOver = null
	
func _process(delta): 
	sortPosition()
	$gold.text = str(hero.gold)
	if Input.is_action_just_pressed("market") && !gameOver: game_over()
	if barbarCurrent == 0 : launch_Barbarian()
	
func launch_Barbarian():
	randomize()
	if(killCount>195) : speed *= 1.5
	if barbarTotal < 200 :
		barbarCurrent += 1
		barbarTotal += 1
		var barbarian_instance = barbarian_scene.instance()
		barbarian_instance.gain = gain
		barbarian_instance.speed = speed
		barbarian_instance.position.x = get_viewport().size.x +10
		barbarian_instance.position.y = rand_range(310, get_viewport().size.y-350)
		add_child(barbarian_instance)
	
func game_over(): 
	if !gameOver && !immune :
		immune = true
		gameOver = gameOver_scene.instance()
		add_child(gameOver)
		for child in get_children(): if child.is_in_group("arrows") : child.queue_free()	
		gameOver.connect("tryAgain", self, "on_tryAgain")
		$Player.get_node("Skin").visible = false

func on_tryAgain(): init()

func victory(): 
	var victory = victory_scene.instance()
	get_parent().add_child(victory)
	queue_free()
	
func onEveryKill(quickDeath = false):
	barbarCurrent -= 1
	if quickDeath : launch_Barbarian()
	elif killCount%2 == 0 : launch_Barbarian()
	hero.addGold(gain)
	killCount += 1
	speed += 6.4
	if killCount % addDumb == 0: 
		addDumb += 4
		launch_Barbarian()
		gain += 15*gainMult if hero.goldDigger else 10*gainMult
	if killCount % 100 == 0 : gainMult += 1
	$score.text =  str(victoryCondition-killCount)
	if killCount == 200 : $VictoryTime.start()

func lifeLost() : 
	if !$Player.invincible :
		$Player.getInvicible()
		if($Player.life != 0) :
			$Player.life -= 1
			$life.text = str($Player.life)
		else : game_over()

func sortPosition():
	var characters = getCharacters()
	characters.sort_custom(self, "sortByY") 
	for i in characters.size() : characters[i].z_index = i
		
func getCharacters():
	var index = 0
	var characters = []
	for child in get_children() : 
		if child.is_in_group("player") || child.is_in_group("ennemies"):
			characters.append(child)
	return characters
	
func sortByY(a, b): return a.position.y < b.position.y 


func _on_Timer_timeout(): immune = false

