extends Area2D

export (int) var speed = 1050
var pers
var huntingBoard = []

func _process(delta): 
	if position.x < get_viewport().size.x : position.x += speed*delta 
	else : queue_free()  
	

func touch(target, persNumber):
	if !target.dead : 
		pers -= 1
		if persNumber > 0 && !huntingBoard[persNumber-1] :
			huntingBoard[persNumber-1] = true
			target.dying(self)	
		elif pers > 0 : touch(target, pers)
		if pers == 0 : queue_free() 

func setPers(nb): 
	pers = nb
	for i in pers :
		huntingBoard.append(false)
	
