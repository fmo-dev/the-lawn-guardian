extends Area2D

var blood_scene = preload("res://scenes/Blood.tscn")
var playerOnIt = false
var stage
var player
var playerInfo
var behindPlayer = false
var gain = 5
var speed
var shortLife = true
var dead = false
var getBlocked = false
var barNb

func _ready(): 
	var nb = randi()%2+1
	barNb = str(nb) if nb > 9 else "0" + str(nb)
	$AnimatedSprite.play('default' + barNb)
	stage = get_parent()
	player = stage.get_node("Player")
	playerInfo = stage.get_parent().get_node("HeroInfo")
	

func _physics_process(delta): 
	if playerOnIt : manageDistance()
	if position.x > 0: position.x -= speed*delta 
	else :
		queue_free()
		stage.game_over()

		

func _on_Barbarian_area_entered(area) :
	if area.is_in_group("arrows"): area.touch(self, area.pers)
	elif area.is_in_group("player") : playerOnIt = true
	order(area, area.position.y > position.y)
	
func unpop(): queue_free()
	
func manageDistance():
	if isBetween(position.y-60, player.position.y, position.y+60) : if !stage.gameOver : falling()
	behindPlayer = true if player.position.y > position.y else false
	order(player, behindPlayer)
	
func order(area, behindArea):
	if behindArea:
		area.z_index = self.z_index + 1
	else : 
		self.z_index = area.z_index + 1
		

func _on_Barbarian_area_exited(area): playerOnIt = false
	
func dying(area): 
	if !dead :
		randomize()
		match randi() % 3+1 :
			1 : $shot.play()
			2 : $shot2.play()
			3 : $shot3.play()
		$ArrowTouch.play()
		vainquish("dying")
		var blood_instance = blood_scene.instance()
		blood_instance.position = area.position
		get_parent().add_child(blood_instance)
	
func falling():
	if !dead :
		vainquish("falling")
		$fall.play()
		stage.lifeLost()
		position.y += -20 if behindPlayer else 20
	
func isBetween(nbMin, nb, nbMax): return nbMin < nb && nb < nbMax

func vainquish(anim) :
	speed = 0;
	$unpopTimer.start()
	$AnimatedSprite.play(anim + barNb)
	stage.onEveryKill(shortLife)
	dead = true

func survive(): shortLife = false
