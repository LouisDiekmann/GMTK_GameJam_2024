extends Node3D
class_name Customer

@export var characterSprite: Sprite3D
@onready var object: Node3D = $object
@onready var objectSizeVectorLength : float = object.scale.length()
@onready var animationPlayer: AnimationPlayer = $characterSprite/AnimationPlayer
@onready var audioStreamPlayer: AudioStreamPlayer = $AudioStreamPlayer


var characters : Array[CompressedTexture2D]
var voice : Array
var objects : Array[MeshInstance3D]
var prompt : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setCharacterSprite()
	setCharacterVoice()
	setObject()
	await get_tree().create_timer(.5).timeout
	playAnimation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("enlarge") and object.scale.x < 2:
		object.scale += Vector3(.01,.01,.01)
	if Input.is_action_pressed("shrink") and object.scale.x > .5:
		object.scale -= Vector3(.01,.01,.01)
		
func _init() -> void:
	pass
	
func setCharacterSprite() -> void:
	var randomInt : int = randi_range(0,2)
	characterSprite.scale = Vector3(.2,.2,.2)
	match randomInt:
		0:
			characterSprite.texture = preload("res://Assets/textures/characters/character1.png")
		1:
			characterSprite.texture = preload("res://Assets/textures/characters/character2.png")
		2:
			characterSprite.texture = preload("res://Assets/textures/characters/character3.png")
			
func setCharacterVoice() -> void:
	pass

func setObject() -> void:
	pass
	
func playAnimation() -> void:
	animationPlayer.play("swoopIn")
	audioStreamPlayer.pitch_scale = randf_range(.5,1.5)
	audioStreamPlayer.play()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "swoopIn":
		animationPlayer.play("wobble")
	
