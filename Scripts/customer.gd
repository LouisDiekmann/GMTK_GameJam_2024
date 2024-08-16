extends Node3D
class_name Customer

@export var characterSprite: Sprite3D

var characters : Array[CompressedTexture2D]
var voice : Array
var object : Array[MeshInstance3D]
var prompt : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setCharacterSprite()
	setCharacterVoice()
	setObject()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
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
