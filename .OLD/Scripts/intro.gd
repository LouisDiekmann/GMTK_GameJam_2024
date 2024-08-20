extends Node3D
@onready var introTextAudio: AudioStreamPlayer = $introTextAudio

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	introTextAudio.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_intro_text_audio_finished() -> void:
	get_parent().nextCustomer(1)
	queue_free()
