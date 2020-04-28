
##############
extends KinematicBody2D

#onready var sprite : Sprite = $Sprite
#onready var animation_player : AnimationPlayer = $AnimationPlayer
#onready var audio_player : AudioStreamPlayer = $AudioStreamPlayer2D
export var snap := false
export var move_speed := 250
export var jump_force := 500
export var gravity := 900
export var slope_slide_threshold := 50.0
var vidas_personaje = 3
var velocity := Vector2()
#var conesion_anima_fin
var nodoprincipal
func _ready():
	nodoprincipal = get_tree().get_root().get_node("Principal")
func _physics_process(delta: float) -> void:
	var direction_x := Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"
	)
	velocity.x = direction_x * move_speed
#	velocity.x = analog_velocity.x* move_speed
	if Input.is_action_just_pressed("ui_up") and snap and not Input.is_action_pressed("abajo"):
		velocity.y = -jump_force
		snap = false
#		audio_player.play()

	velocity.y += gravity * delta

	var snap_vector = Vector2(0,32) if snap else Vector2()
	velocity = move_and_slide_with_snap(velocity,snap_vector, Vector2.UP, slope_slide_threshold)

	if is_on_floor() and (Input.is_action_just_released("move_right") or Input.is_action_just_released("move_left")):
		velocity.y = 0

	var just_landed := is_on_floor() and not snap
	if just_landed:
		snap = true
	
	
