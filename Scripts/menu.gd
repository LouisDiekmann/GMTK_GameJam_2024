extends CanvasLayer
@onready var curtainsClosed : bool = true
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var audioOpenCurtain: AudioStreamPlayer = $curtainOpen
@onready var audioCloseCurtain: AudioStreamPlayer = $curtainClose
@onready var settingsPanel: Panel = $Settings
@onready var menuButtons: VBoxContainer = $menuButtons

@onready var creditsPlaying : bool = false

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("menu"):
		if creditsPlaying:
			$menuButtons.visible = true
			$Credits/creditsAnimation.stop()
		pause()

func closeCurtains() -> void:
	curtainsClosed = not curtainsClosed
	animationPlayer.play("closeCurtains")
	audioCloseCurtain.pitch_scale = randf_range(0.7, 1.3)
	await get_tree().create_timer(.3).timeout
	audioCloseCurtain.play()
	menuButtons.visible = true
	
func openCurtains() -> void:
	curtainsClosed = not curtainsClosed
	animationPlayer.play("openCurtains")
	audioOpenCurtain.pitch_scale = randf_range(0.7, 1.3)
	audioOpenCurtain.play()
	menuButtons.visible = false
	
func playCredits() -> void:
	creditsPlaying = true
	$menuButtons.visible = false 
	$Credits/creditsAnimation.play("credits")
	await get_tree().create_timer(50).timeout
	if curtainsClosed:
		$menuButtons.visible = true
	creditsPlaying = false
	
func _on_music_volume_drag_ended(value_changed: bool) -> void:
	pass # Replace with function body.

func pause() -> void:
		if not curtainsClosed and get_parent().currentCustomer is Customer:
			closeCurtains()
			get_parent().currentCustomer.queue_free()
