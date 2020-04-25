extends Node

var speed = 300
var arrowDelay = 1
var arrowPers = 1
var life = 3
var gold = 0
var goldDigger = false 

var improvePoint = 0

func addGold(qt) : gold += qt
	
func addSpeed() : speed += 50
	
func subArrowDelay() : arrowDelay -= 0.05

func addArrowPers() : arrowPers += 1

func addLife() : life += 1

func goldDigging() : goldDigger = true


