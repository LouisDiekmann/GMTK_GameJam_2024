extends CanvasLayer
@onready var curtainsClosed : bool = true
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var audioOpenCurtain: AudioStreamPlayer = $curtainOpen
@onready var audioCloseCurtain: AudioStreamPlayer = $curtainClose
@onready var creditsPanel: Panel = $Credits
@onready var settingsPanel: Panel = $Settings
@onready var menuButtons: VBoxContainer = $menuButtons

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("menu"):
		pause()
			
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
	
func _on_music_volume_drag_ended(value_changed: bool) -> void:
	pass # Replace with function body.

func _on_pause_button_button_down() -> void:
	pause()

func pause() -> void:
	if not curtainsClosed:
		closeCurtains()
	else:
		openCurtains()
	changePauseIcon()
	
func changePauseIcon() -> void:
	if not curtainsClosed:
		$pauseButton.texture_normal = load("res://Assets/textures/GhostButton.png")
		$pauseButton.texture_hover = load("res://Assets/textures/GhostButtonOff.png")
		$pauseButton.texture_pressed = load("res://Assets/textures/GhostButtonOff.png")
	else:
		$pauseButton.texture_normal = load("res://Assets/textures/pauseButton.png")
		$pauseButton.texture_hover = load("res://Assets/textures/pauseButtonHover.png")
		$pauseButton.texture_pressed = load("res://Assets/textures/pauseButtonHover.png")
