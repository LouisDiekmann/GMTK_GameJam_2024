extends Node3D
@onready var newCustomer : PackedScene = preload("res://Scenes/customer.tscn")
@onready var autoRotateObject : bool = true
@onready var ghostHidden : bool = false
var score : int

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
	validateObjectSize()
	removeCurrentCustomer()
	nextCustomer()
	
func validateObjectSize() -> int:
	score = 1
	return score
	
func removeCurrentCustomer() -> void:
	pass

func nextCustomer() -> void:
	add_child(newCustomer.instantiate())
	
func stopRotationToggled(toggled : bool) -> void:
	autoRotateObject = not toggled
	
func hideGhostObject(toggled : bool) -> void:
	ghostHidden = toggled

func getAutoRotateObject() -> bool:
	return autoRotateObject
	
func getGhostHidden() -> bool:
	return ghostHidden
	
