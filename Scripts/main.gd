extends Node3D
@onready var newCustomer : PackedScene = preload("res://Scenes/customer.tscn")
@onready var intro : PackedScene = preload("res://Scenes/intro.tscn")
@onready var autoRotateObject : bool = true
@onready var ghostHidden : bool = false
@onready var introPlayed : bool = false
@onready var scoreLabel: Label = $score/Panel/MarginContainer/HBoxContainer/currentScore
@onready var customerCountLabel: Label = $score/Panel/MarginContainer/HBoxContainer/customerCount
@onready var goalScore: Label = $score/Panel/MarginContainer/HBoxContainer/goalScore


var score : int = 0
var customerCount : int = 0
var currentCustomer : Customer

const cursorGauntlet1 = preload("res://Assets/textures/cursorGauntlet1.png")
const cursorGauntlet2 = preload("res://Assets/textures/cursorGauntlet2.png")

@onready var level : Dictionary = {
	1: Vector2(5,1500),
	2: Vector2(10,4000),
	3: Vector2(15,6800)
}
@onready var currentLevel : int = 1

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("enlarge"):
		Input.set_custom_mouse_cursor(cursorGauntlet2)
	if Input.is_action_just_released("enlarge"):
		Input.set_custom_mouse_cursor(cursorGauntlet1)
	
func startGame() -> void:
	if not introPlayed:
		add_child(intro.instantiate())
	else:
		nextCustomer(1)
	introPlayed = true

func confirmSizePressed() -> void:
	var thisScore : int = validateObjectSize()
	score += thisScore
	scoreLabel.text = str(score)
	removeCurrentCustomer(thisScore)
	customerCount += 1
	customerCountLabel.text = str(customerCount) + "/" +  str(level[currentLevel].x)
	nextCustomer(0)

func _ready() -> void:
	customerCountLabel.text = str(customerCount) + "/" + str(level[currentLevel].x)
	goalScore.text = str(level[currentLevel].y)

func validateObjectSize() -> int:
	var thisScore : int = 500
	var relativeSizes : Vector3 = currentCustomer.getRelativeSizes()
	var objective : Dictionary = currentCustomer.getObjective()

	var objectiveSize : float = objective["size"]
	var sizeDifference : Vector3 = relativeSizes - Vector3(100,100,100)
	
	var scoreMultiplyer : Vector3
	if sizeDifference.x > 0:
		scoreMultiplyer = abs(sizeDifference - Vector3(objectiveSize, objectiveSize, objectiveSize))
	else:
		scoreMultiplyer = abs(sizeDifference + Vector3(objectiveSize, objectiveSize, objectiveSize))
	
	print("sm: ", scoreMultiplyer)
	
	if objective["direction"] == "smaller" and sizeDifference.x > 0:
		return 0
	if objective["direction"] == "bigger" and sizeDifference.x < 0:
		return 0
		
	match objective["unit"]:
		"scale":
			thisScore = calculateScore(scoreMultiplyer.x)
		"surface":
			thisScore = calculateScore(scoreMultiplyer.y)
		"volume":
			thisScore = calculateScore(scoreMultiplyer.z)
			
	return thisScore

func calculateScore(value : float) -> int:
	var calcScore: int
	if value >= 10: 
		calcScore = 500 - int(value) * 5
		if calcScore < 0: 
			calcScore = 0
	else:
		calcScore = 500
	return calcScore

func removeCurrentCustomer(score : int) -> void:
	var toBeRemovedCustomer : Customer = currentCustomer
	toBeRemovedCustomer.playResponse(score)

func nextCustomer(value : int) -> void:
	if customerCount < level[currentLevel].x:
		if value == 0:
			await get_tree().create_timer(1).timeout
		currentCustomer = newCustomer.instantiate()
		add_child(currentCustomer)
	else:
		levelEnd()

func levelEnd() -> void:
	if score >= level[currentLevel].y:
		winScreen()
	else:
		loseScreen()

func winScreen() -> void:
	print("you win")
	nextLevel()

func nextLevel() ->  void:
	if currentLevel < 3:
		currentLevel += 1
		resetLevel()
		nextCustomer(0)
	else:
		resetLevel()
		$menu.closeCurtains()

func loseScreen() -> void:
	print("you lose")
	resetLevel()
	$menu.closeCurtains()

func resetLevel() -> void:
	customerCount = 0
	score = 0
	customerCountLabel.text = str(customerCount) + "/" + str(level[currentLevel].x)
	scoreLabel.text = str(score)
	goalScore.text = str(level[currentLevel].y)

func getAutoRotateObject() -> bool:
	return autoRotateObject
	
func getGhostHidden() -> bool:
	return ghostHidden
	
