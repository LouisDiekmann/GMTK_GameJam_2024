extends CanvasLayer

@export var mainNode : Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_confirm_pressed() -> void:
	mainNode.call("confirmSizePressed")

func _on_next_pressed() -> void:
	mainNode.call("nextCustomerPressed")

func _on_stop_rotation_toggled(toggled_on: bool) -> void:
	mainNode.call("stopRotationToggled", toggled_on)

func _on_hide_ghost_toggled(toggled_on: bool) -> void:
	mainNode.call("hideGhostObject", toggled_on)
