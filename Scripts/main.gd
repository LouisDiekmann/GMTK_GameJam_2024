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
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func startGame() -> void:
	nextCustomer()

func confirmSizePressed() -> void:
	score += validateObjectSize()
	print(score)
	scoreLabel.text = str(score)
	removeCurrentCustomer()
	nextCustomer()
	
func validateObjectSize() -> int:
	var thisScore : int = 500
	var relativeSizes : Vector3 = currentCustomer.getRelativeSizes()
	var objective : Dictionary = currentCustomer.getObjective()

	var objectiveSize : float = objective["size"]
	var sizeDifference : Vector3 = abs(relativeSizes - Vector3(100,100,100))
	print(sizeDifference)
	print(objectiveSize)
	match objective["unit"]:
		"scale":
			if abs(sizeDifference.x - objectiveSize) >= 10:
				thisScore = 500 - abs(sizeDifference.x - objectiveSize)*15
				if thisScore < 0 : thisScore = 0
			else:
				thisScore = 500
		"surface":
			if abs(sizeDifference.y - objectiveSize) >= 10:
				thisScore = 500 - abs(sizeDifference.y - objectiveSize)*15
				if thisScore < 0 : thisScore = 0
			else:
				thisScore = 500
		"volume":
			if abs(sizeDifference.z - objectiveSize) >= 10:
				thisScore = 500 - abs(sizeDifference.z - objectiveSize)*15
				if thisScore < 0 : thisScore = 0
			else:
				thisScore = 500

	return thisScore
	
func removeCurrentCustomer() -> void:
	currentCustomer.queue_free()

func nextCustomer() -> void:
	currentCustomer = newCustomer.instantiate()
	add_child(currentCustomer)
	
func stopRotationToggled(toggled : bool) -> void:
	autoRotateObject = not toggled
	
func hideGhostObject(toggled : bool) -> void:
	ghostHidden = toggled

func getAutoRotateObject() -> bool:
	return autoRotateObject
	
func getGhostHidden() -> bool:
	return ghostHidden
	
