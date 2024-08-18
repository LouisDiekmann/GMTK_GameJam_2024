extends Node3D
class_name Customer

var objective : Dictionary
var relativeSizes : Vector3
var rotating : bool = true
var ghost : bool = true
var scaleable : bool = false
var scaleSpeed : int = 50

@onready var autoRotate : bool = true
@export var characterSprite: Sprite3D

@onready var parent : Node3D = get_parent()

@onready var ghostButton: TextureButton = $objectController/VBoxContainer/ghostButton
@onready var rotateButton: TextureButton = $objectController/VBoxContainer/rotateButton


@onready var object: Node3D = $object
@onready var scaleableObject: StaticBody3D = $object/scaleable
@onready var referanceObject: MeshInstance3D = $object/referanceMesh

@onready var objectSizeVectorLength : float = object.scale.length()
@onready var animationPlayer: AnimationPlayer = $characterSprite/AnimationPlayer
@onready var audioPlayerSwoop : AudioStreamPlayer = $playerSwoop
@onready var audioClick: AudioStreamPlayer = $click

@onready var flavorText: Label = $Panel/MarginContainer/VBoxContainer/flavorText
@onready var objectiveText: Label = $Panel/MarginContainer/VBoxContainer/objectiveText
@onready var cheatLabel: Label = $Panel/MarginContainer/VBoxContainer/cheatLabel

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
	objective = createObjective()
	
	await get_tree().create_timer(.5).timeout
	setupAndAnimateView()

func _process(delta: float) -> void:
	relativeSizes = calculateRelativeSizes()
	cheatLabel.text = "Scale: " + str(snapped(relativeSizes.x, 0.01) ) + " Surface: " + str(snapped(relativeSizes.y, 0.01)) + " Volume: " + str(snapped(relativeSizes.z, 0.01))
	
	if scaleable:
		scaleObject()
		
	if rotating:
		object.rotation += Vector3(.002,.002,.002)

	referanceObject.visible = ghost

func scaleObject() -> void:
	if Input.is_action_just_pressed("enlarge") or Input.is_action_just_pressed("shrink"):
		audioClick.pitch_scale = randf_range(.8,1.2)
		audioClick.play()
	if Input.is_action_just_released("enlarge") or Input.is_action_just_released("shrink"):
		audioClick.stop()
	
	var scaler : Vector3 = Vector3(0.0001 * scaleSpeed, 0.0001 * scaleSpeed, 0.0001 * scaleSpeed)
	if Input.is_action_pressed("enlarge") and scaleableObject.scale.x < 2:
		scaleableObject.scale += scaler
	if Input.is_action_pressed("shrink") and scaleableObject.scale.x > .2:
		scaleableObject.scale -= scaler

func calculateRelativeSizes() -> Vector3:
	var scaledVec3 : Vector3 = scaleableObject.scale
	var referanceVec3 : Vector3 = referanceObject.scale
	
	var volumeInPercent : float = (scaledVec3.x * scaledVec3.y * scaledVec3.z) * 100
	var surfaceInPercent : float = (scaledVec3.x * scaledVec3.y) *100
	var scaleInPercent : float = scaledVec3.x * 100
	
	var relativeSizes : Vector3 = Vector3(scaleInPercent, surfaceInPercent, volumeInPercent)
	return relativeSizes

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

func createObjective() -> Dictionary :
	var direction : String
	var size : int  
	var unit : String
	
	var randInt1 : int = randi_range(0,1)
	match randInt1:
		0:
			direction = "smaller"
		1:
			direction = "bigger"
	
	var randInt2 : int = randi_range(0,2)
	match randInt2:
		0:
			unit = "scale"
		1:
			unit = "surface"
		2:
			unit = "volume"
	
	match direction:
		"bigger":
			var randInt3 : int = randi_range(1,20)
			match unit:
				"scale":
					size = randInt3 * 5
				"surface":
					size = randInt3 * 10
				"volume":
					size = randInt3 * 20
		"smaller":
			var randInt4 : int = randi_range(1,16)
			size = randInt4 * 5
	
	var objectiveDict : Dictionary = {
		"direction" : direction,
		"size" : size,
		"unit" : unit,
	}
	
	return objectiveDict

func setupAndAnimateView() -> void:
	animationPlayer.play("swoopIn")
	audioPlayerSwoop.pitch_scale = randf_range(.5,1.5)
	audioPlayerSwoop.play()
	flavorText.text = textLines[objective["direction"]][randi_range(0,2)]
	objectiveText.text = "Make the objects " + objective["unit"] + " " + str(objective["size"]) + " % " + objective["direction"]

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "swoopIn":
		animationPlayer.play("wobble")

func getRelativeSizes() -> Vector3:
	return relativeSizes
	
func getObjective() -> Dictionary:
	return objective

func _on_scaleable_mouse_entered() -> void:
	scaleable = true

func _on_scaleable_mouse_exited() -> void:
	scaleable = false


func _on_ghost_button_toggled(toggled_on: bool) -> void:
	ghost = not toggled_on
	
func _on_rotate_button_toggled(toggled_on: bool) -> void:
	rotating = not toggled_on

func _on_button_mouse_entered() -> void:
	$paper2.play()

func _on_scale_speed_drag_ended(value_changed: bool) -> void:
	scaleSpeed = $objectController/VBoxContainer/scaleSpeed.value
