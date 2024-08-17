extends CanvasLayer
@onready var curtainsClosed : bool = true
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var audioOpenCurtain: AudioStreamPlayer = $curtainOpen
@onready var audioCloseCurtain: AudioStreamPlayer = $curtainClose

@onready var menuButtons: VBoxContainer = $menuButtons


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("menu"):
		if not curtainsClosed:
			closeCurtains()
		else:
			openCurtains()
			
func closeCurtains() -> void:
	animationPlayer.play("closeCurtains")
	audioCloseCurtain.pitch_scale = randf_range(0.7, 1.3)
	await get_tree().create_timer(.3).timeout
	audioCloseCurtain.play()
	menuButtons.visible = true
	curtainsClosed = not curtainsClosed
	
func openCurtains() -> void:
	animationPlayer.play("openCurtains")
	audioOpenCurtain.pitch_scale = randf_range(0.7, 1.3)
	audioOpenCurtain.play()
	menuButtons.visible = false
	curtainsClosed = not curtainsClosed
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menuButtons.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
