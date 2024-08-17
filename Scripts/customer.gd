extends Node3D
class_name Customer

var objective : String
var objectiveValue : int
@export var characterSprite: Sprite3D
@onready var object: Node3D = $object
@onready var objectSizeVectorLength : float = object.scale.length()
@onready var animationPlayer: AnimationPlayer = $characterSprite/AnimationPlayer
@onready var audioStreamPlayer: AudioStreamPlayer = $AudioStreamPlayer
@onready var label3D: Label3D = $Label3D

@onready var textLines : Dictionary = {
	"smaller" : {
		0 : "This is way to big for what I want to use it for!",
		1 : "This dang thing needs to fit inside of me pocket",
		2 : "Where de hell am I supposed to store this giant piece of garabge?"
	},
	"bigger" : {
		0 : "I need this thing to fit more Beer!",
		1 : "I brought me donkey to bring this home! Better make it worth the effort, ey?",
		2 : "Don't worry about it mate. I just need to fit in this somehow.",
	}
}

var objects : Array[MeshInstance3D]
var prompt : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setCharacterSprite()
	setCharacterVoice()
	setObject()
	setObjective()
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

func setObjective() -> void :
	var randInt1 : int = randi_range(0,1)
	match randInt1:
		0:
			objective = "smaller"
		1:
			objective = "bigger"
	
	var randInt2 : int = randi_range(1,10)
	objectiveValue  = randInt2 * 5
	
# @method used to play the inital animations, sounds and text reveals when a new customer enters the scene
func playAnimation() -> void:
	animationPlayer.play("swoopIn")
	audioStreamPlayer.pitch_scale = randf_range(.5,1.5)
	audioStreamPlayer.play()
	label3D.text = textLines[objective][randi_range(0,2)]

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "swoopIn":
		animationPlayer.play("wobble")
	
