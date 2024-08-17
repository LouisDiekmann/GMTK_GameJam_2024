extends CanvasLayer
var curtainsClosed : bool
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var audioOpenCurtain: AudioStreamPlayer = $curtainOpen
@onready var audioCloseCurtain: AudioStreamPlayer = $curtainClose


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("menu"):
		curtainsClosed = not curtainsClosed
		if curtainsClosed:
			animationPlayer.play("closeCurtains")
			audioCloseCurtain.pitch_scale = randf_range(0.7, 1.3)
			await get_tree().create_timer(.3).timeout
			audioCloseCurtain.play()
		else:
			animationPlayer.play("openCurtains")
			audioOpenCurtain.pitch_scale = randf_range(0.7, 1.3)
			audioOpenCurtain.play()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
