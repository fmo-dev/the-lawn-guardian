extends Control

var hero

var speedAttackPrice
var speedMovementPrice
var lifePrice
var arrowStrengthPrice
var goldDiggerPrice

var speedAttackPriceInit = 150
var speedMovementPriceInit  = 100
var lifePriceInit  = 75
var arrowStrengthPriceInit  = 200

var goldIndic

func _ready(): 
	hero = get_node("../../../HeroInfo")
	arrowStrengthPrice = arrowStrengthPriceInit*(pow(10,(hero.arrowPers)))
	speedMovementPrice = speedMovementPriceInit
	speedAttackPrice = speedAttackPriceInit
	lifePrice = lifePriceInit
	goldDiggerPrice = 2500
	refreshPrice()
	
func refreshPrice():
	$GoldHero.text = str(hero.gold)
	displayItem($GoldDiggerPrice, goldDiggerPrice, $GoldGoldDigger)
	if hero.goldDigger : maxItem($buyGoldDigger, $GoldDiggerPrice, $GoldGoldDigger, "Bought") 

	speedAttackPrice = speedAttackPriceInit * round(((105 - (hero.arrowDelay*100) ) / 5) / hero.arrowDelay)
	if round(hero.arrowDelay*100) <= 60 : speedAttackPrice*=4
	if round(hero.arrowDelay*100) == 25 : speedAttackPrice = speedAttackPriceInit * 2800
	elif speedAttackPrice != speedAttackPriceInit : speedAttackPrice += round(speedAttackPrice*0.5)
	displayItem($SpeedAttackPrice, speedAttackPrice, $GoldSpeedAttack, $SpeedAttack, stepify(1 / hero.arrowDelay, 0.01))
	if round(hero.arrowDelay*100) == 20 : maxItem($ImpSpeedAttack, $SpeedAttackPrice, $GoldSpeedAttack)
	
	speedMovementPrice = speedMovementPriceInit * ((hero.speed - 250) / 50)
	if hero.speed >= 600 : speedMovementPrice*=50
	elif hero.speed >= 500 : speedMovementPrice*=25
	elif hero.speed >= 400 : speedMovementPrice*=10
	if speedMovementPrice != speedMovementPriceInit : speedMovementPrice += round(speedMovementPrice*0.3)
	displayItem($SpeedPrice, speedMovementPrice, $GoldSpeed, $SpeedMovemen, hero.speed)
	if hero.speed == 700 : maxItem($ImSpeedMovemen, $SpeedPrice, $GoldSpeed)

	lifePrice = lifePriceInit * (hero.life-1)
	if hero.life >= 6 : lifePrice*=2
	if lifePrice != lifePriceInit : lifePrice += round(lifePrice*0.2)
	displayItem($LifePrice, lifePrice, $GoldLife, $Life, hero.life)
	if  hero.life == 10 : maxItem($ImpLife, $LifePrice, $GoldLife)

	arrowStrengthPrice = arrowStrengthPriceInit*(pow(10,(hero.arrowPers)))
	displayItem($ArrowStrengthPrice, arrowStrengthPrice, $GoldArrowStrength, $ArrowStrength, hero.arrowPers)
	if hero.arrowPers == 4 : maxItem($ImpArrowStrength4, $ArrowStrengthPrice, $GoldArrowStrength)


func maxItem(button, price, gold, txt = "Max") :
	price.text = txt
	price.set("custom_colors/font_color", Color(0.5, 0.8, 0.2))
	gold.text = ""
	if is_instance_valid(button) : button.queue_free()

func displayItem(labelPrice, price, labelGold, labelhero = null, heroInfo = null) :
	labelPrice.text = str(price)
	if labelhero && heroInfo: labelhero.text = str(heroInfo)
	if hero.gold < price : 
		labelPrice.set("custom_colors/font_color", Color(1,0,0))
		labelGold.set("custom_colors/font_color", Color(1,0,0))
	else :
		labelPrice.set("custom_colors/font_color", Color(0.8, 1, 0.6))
		labelGold.set("custom_colors/font_color", Color(0.8, 1, 0.6))
		
func purchase_Life(): pay(lifePrice, funcref(hero, "addLife")) 
func purchase_SpeedMovement(): pay(speedMovementPrice, funcref(hero, "addSpeed")) 
func purchase_ArrowStrength(): pay(arrowStrengthPrice, funcref(hero, "addArrowPers")) 
func purchase_SpeedAttack(): pay(speedAttackPrice, funcref(hero, "subArrowDelay"))
func purchase_GoldDigger(): pay(goldDiggerPrice,  funcref(hero, "goldDigging"))

func pay(price, callback):
	if hero.gold >= price:
		$coin.play()
		hero.improvePoint += 1
		hero.gold -= price
		callback.call_func()
		print(hero.improvePoint)
		refreshPrice()
