extends VBoxContainer

@export var menuNode : CanvasLayer
@export var mainNode : Node3D
@onready var paper: AudioStreamPlayer = $paper
@onready var paper2: AudioStreamPlayer = $paper2
@onready var play: Button = $Play
@onready var resume: Button = $Resume

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_down() -> void:
	paper.play()
	play.visible = false
	resume.visible = true
	menuNode.openCurtains()
	mainNode.startGame()
	
func _on_resume_button_down() -> void:
	paper.play()
	menuNode.openCurtains()

func _on_credits_button_down() -> void:
	paper.play()
	menuNode.creditsPanel.visible = not menuNode.creditsPanel.visible

func _on_settings_button_down() -> void:
	paper.play()
	menuNode.settingsPanel.visible = not menuNode.settingsPanel.visible

func _on_exit_button_down() -> void:
	get_tree().quit()

func _on_mouse_entered() -> void:
	paper2.play()
