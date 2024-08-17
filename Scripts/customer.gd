extends Node3D
class_name Customer

var objective : String
var objectiveValue : int
@onready var autoRotate : bool = true
@export var characterSprite: Sprite3D

@onready var parent : Node3D = get_parent()

@onready var object: Node3D = $object
@onready var scaleableObject: MeshInstance3D = $object/scaleable
@onready var referanceObject: MeshInstance3D = $object/referance

@onready var objectSizeVectorLength : float = object.scale.length()
@onready var animationPlayer: AnimationPlayer = $characterSprite/AnimationPlayer
@onready var audioPlayerSwoop : AudioStreamPlayer = $playerSwoop
@onready var audioClick: AudioStreamPlayer = $click

@onready var flavorText: Label3D = $flavorText
@onready var objectiveText: Label3D = $objectiveText
@onready var cheatLabel: Label3D = $cheatLabel

@onready var textLines : Dictionary = {
	"smaller" : {
		0 : "This is way to big for what I want to use it for!",
		1 : "This dang thing needs to fit inside of me pocket",
		2 : "Where de hell am I supposed to store this giant piece of garbage?"
	},
	"bigger" : {
		0 : "I need this thing to fit more Beer!",
		1 : "I brought me donkey to bring this home! Better make it worth the effort, ey?",
		2 : "Don't worry about it mate. I just need to fit in this somehow.",
	}
}

var objects : Array[MeshInstance3D]
var prompt : Array

func _ready() -> void:
	setCharacterSprite()
	setCharacterVoice()
	setObject()
	setObjective()
	await get_tree().create_timer(.5).timeout
	playAnimation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	calculateRelativeVolume()
	calculateRelativeSurface()
		
	if Input.is_action_just_pressed("enlarge") or Input.is_action_just_pressed("shrink"):
		audioClick.pitch_scale = randf_range(.8,1.2)
		audioClick.play()
	if Input.is_action_just_released("enlarge") or Input.is_action_just_released("shrink"):
		audioClick.stop()
	
	if Input.is_action_pressed("enlarge") and scaleableObject.scale.x < 2:
		scaleableObject.scale += Vector3(.01,.01,.01)
	if Input.is_action_pressed("shrink") and scaleableObject.scale.x > .2:
		scaleableObject.scale -= Vector3(.01,.01,.01)
		
	if parent.call("getAutoRotateObject"):
		object.rotation += Vector3(.002,.002,.002)
		
	referanceObject.visible = not parent.call("getGhostHidden")

func calculateRelativeVolume() -> float:
	var scaledVec3 : Vector3 = scaleableObject.scale
	var scaledObjectVolume : float = scaledVec3.x * scaledVec3.y * scaledVec3.z
	var referanceVec3 : Vector3 = referanceObject.scale
	var referanceObjectVolume : float = referanceVec3.x * referanceVec3.y * referanceVec3.z
	
	var x := floorf((referanceObjectVolume * (scaledObjectVolume / 100)) * 100)
	
	print(scaledObjectVolume)
	print("R", referanceObjectVolume)
	
	cheatLabel.text = str(x) + " times bigger"
	
	
	return 1
	
func calculateRelativeSurface() -> float:
	return 1

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

func setObjective() -> void :
	var randInt1 : int = randi_range(0,1)
	match randInt1:
		0:
			objective = "smaller"
		1:
			objective = "bigger"
	
	var randInt2 : int = randi_range(1,10)
	objectiveValue  = randInt2 * 5
	
	objectiveText.text = "make the object " + str(objectiveValue) + "% " + str(objective)
	
# @method used to play the inital animations, sounds and text reveals when a new customer enters the scene
func playAnimation() -> void:
	animationPlayer.play("swoopIn")
	audioPlayerSwoop.pitch_scale = randf_range(.5,1.5)
	audioPlayerSwoop.play()
	flavorText.text = textLines[objective][randi_range(0,2)]

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "swoopIn":
		animationPlayer.play("wobble")
	
