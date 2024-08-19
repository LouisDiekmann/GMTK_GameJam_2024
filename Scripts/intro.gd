extends Node3D
@onready var introTextAudio: AudioStreamPlayer = $introTextAudio

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	introTextAudio.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_intro_text_audio_finished() -> void:
	await get_tree().create_timer(2).timeout
	get_parent().nextCustomer()
	queue_free()
