extends Node3D
@onready var newCustomer : PackedScene = preload("res://Scenes/customer.tscn")
var autoRotateObject : bool
var ghostHidden : bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func confirmSizePressed() -> void:
	print("confirm")

func nextCustomerPressed() -> void:
	print("next")
	add_child(newCustomer.instantiate())
	
func stopRotationToggled(toggled : bool) -> void:
	autoRotateObject = toggled
	
func hideGhostObject(toggled : bool) -> void:
	ghostHidden = toggled

func getAutoRotateObject() -> bool:
	return autoRotateObject
	
func getGhostHidden() -> bool:
	return ghostHidden
	
