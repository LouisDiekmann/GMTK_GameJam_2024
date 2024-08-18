extends Node3D
@onready var newCustomer : PackedScene = preload("res://Scenes/customer.tscn")
@onready var autoRotateObject : bool = true
@onready var ghostHidden : bool = false
@onready var scoreLabel: Label = $menu/scoreLabel

var score : int
var currentCustomer : Customer

const cursorGauntlet1 = preload("res://Assets/textures/cursorGauntlet1.png")
const cursorGauntlet2 = preload("res://Assets/textures/cursorGauntlet2.png")

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("enlarge"):
		Input.set_custom_mouse_cursor(cursorGauntlet2)
	if Input.is_action_just_released("enlarge"):
		Input.set_custom_mouse_cursor(cursorGauntlet1)

	
func startGame() -> void:
	nextCustomer()

func confirmSizePressed() -> void:
	score += validateObjectSize()
	scoreLabel.text = str(score)
	removeCurrentCustomer()
	nextCustomer()
	
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
		calcScore = 500 - int(value) * 15
		if calcScore < 0: 
			calcScore = 0
	else:
		calcScore = 500
	return calcScore

func removeCurrentCustomer() -> void:
	currentCustomer.queue_free()

func nextCustomer() -> void:
	currentCustomer = newCustomer.instantiate()
	add_child(currentCustomer)

func getAutoRotateObject() -> bool:
	return autoRotateObject
	
func getGhostHidden() -> bool:
	return ghostHidden
	
