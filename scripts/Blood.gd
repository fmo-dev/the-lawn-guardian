extends Node2D

var bloods

func _ready(): 
	bloods = [$Main, $Back3, $Back2, $Back1]
	for i in bloods.size() : bloods[i].play("default")



func _process(delta): 
	for i in bloods.size() :
		var indic = 1 if i > 0 else 0
		bloods[i].position.x +=  200*delta * indic
		bloods[i].position.y +=  0 if i%2 == 0 else 5*delta * (i-2) 
		bloods[i].modulate.a -= delta*4
	
		
		
	
func _on_AnimatedSprite_animation_finished(): queue_free()

