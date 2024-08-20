extends Node3D
@export var SPEED : float = 1
@export var AMPLITUDE : float = 1
var timePassed : float = 0
var cameraPosition : Vector3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cameraPosition = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	timePassed += delta
	position.y = cameraPosition.y + sin(timePassed * SPEED) * AMPLITUDE
	rotation.z = deg_to_rad(cos(timePassed * 1.8) * .25)
