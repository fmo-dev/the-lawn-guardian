extends Area2D

var speed
var arrowDelay
var arrowPers
var life
var arrow_scene = preload("res://scenes/Arrow.tscn")
var canShot = true
const MOVE = ["up", "right", "down", "left"]
var stage
var invincible

func _ready(): stage = get_parent()

func _process(delta): 
	if(!stage.gameOver) :
		var directions = []
		for i in MOVE.size() : if Input.is_action_pressed(MOVE[i]) : directions.push_back(i)
		if directions.size() == 0 : $Skin/Legs.play("defaultLeg")
		else : for j in directions.size() : move(directions[j], delta)
		if Input.is_action_pressed("shot") : shot()
		else : $Skin/Top.play("defaultTop")

# MOVING

func move(i, delta): 
	$Skin/Legs.play("move")
	var direction = Vector2(i%2*(2-i), (i+1)%2*(i-1))
	position += speed * delta * direction
	position = stayIn(position, get_viewport().size) 


func stayIn(pos, vecMax) : return Vector2(block(50, pos.x, vecMax.x-40), block(310, pos.y, vecMax.y-350))

func block(nbMin, nb, nbMax) : return nb if nbMin <= nb && nb <= nbMax else nbMin if nb < nbMin else nbMax

# SHOOTING

func shot(): 
	if canShot :
		$arrowSound.play()
		$Skin/Top.play("shot1")
		var arrow_instance = arrow_scene.instance()
		arrow_instance.setPers(arrowPers)
		arrow_instance.position = $Arrow_position.global_position
		get_parent().add_child(arrow_instance)
		canShot = false
		$shotDelay.start()	
		$Skin.get_node("ProgressBar").visible = true
		$Skin.get_node("ProgressBar").start()
	elif $shotDelay.get_time_left() <  $shotDelay.wait_time/2 : $Skin/Top.play("shot2")

func canShotAgain(): 
	canShot = true
	$Skin.get_node("ProgressBar").stop()
	$Skin.get_node("ProgressBar").visible = false

func getInvicible(): 
	invincible = true
	$invicibleTime.start()
	$colorMark.start()




func _on_colorMark_timeout():
	var red = Color(0.9,0.2,0.2,1)
	if invincible : $Skin.modulate = Color(1, 1, 1, 1) if $Skin.modulate == red else red
	else : $colorMark.stop()
		


func _on_invicibleTime_timeout(): invincible = false
