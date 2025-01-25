extends CharacterBody2D

@onready var collision_shape := $BubbleCollisionShape
@onready var bubble_particles := $BubbleCollisionShape/CPUParticles2D

@export var num : float
@export var blowdown_curve: Curve

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ORIGINAL_SCALE_SPEED = 2.0
@onready var ORIGINAL_SCALE = get_bubble_scale() # Vector2(1.0, 1.0)  # Original scale of the object
@onready var MAX_SCALE = ORIGINAL_SCALE * 3 #Vector2(1.0, 1.0) * 5  # Original scale of the object
@onready var MIN_SCALE = ORIGINAL_SCALE * 0.3 #Vector2(1.0, 1.0) * 0.3
const SCALE_SPEED = 2.0  # Speed of scaling
var TARGET_SCALE = scale  # Target scale when key is pressed
var is_scaling_up = false  # Whether the object is scaling up

var upwards_force := 0.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	handle_horizontal_movement()
	handle_bubble_scale(delta)
	
	upwards_force = get_bubble_scale().length()
	velocity.y -= upwards_force * 5
	
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal()) * 0.5
		move_and_slide()
	
func handle_bubble_scale(delta):
	var curr_scale = get_bubble_scale()
	if Input.is_action_pressed("ui_accept"):
		is_scaling_up = true
		TARGET_SCALE = curr_scale + Vector2(0.05,0.05)
		if TARGET_SCALE > MAX_SCALE:
			TARGET_SCALE = MAX_SCALE
		set_bubble_scale(TARGET_SCALE)
		curr_scale = get_bubble_scale()
	
	if is_scaling_up:
		bubble_particles.set_emitting(false)
		if curr_scale.distance_to(TARGET_SCALE) < 0.01:
			curr_scale = TARGET_SCALE  # Snap to target scale
			is_scaling_up = false
	else:
		bubble_particles.set_emitting(true)
		if curr_scale > MIN_SCALE:
			var scaleRatioX = (MAX_SCALE.x - curr_scale.x) / (MAX_SCALE.x - MIN_SCALE.x)
			var scaleRatioY = (MAX_SCALE.y - curr_scale.y) / (MAX_SCALE.y - MIN_SCALE.y)
			var curveCurrentPointX = blowdown_curve.sample(scaleRatioX)
			var curveCurrentPointY = blowdown_curve.sample(scaleRatioY)
			var curvePointX = blowdown_curve.sample(scaleRatioX+delta)
			var curvePointY = blowdown_curve.sample(scaleRatioY+delta)
			var diffX = MAX_SCALE.x*(curveCurrentPointX-curvePointX)
			var diffY = MAX_SCALE.y*(curveCurrentPointY-curvePointY)
			print_debug("diff",diffX)
			print_debug("diff",diffX)
			curr_scale = Vector2(curr_scale.x-diffX,curr_scale.y-diffY)
		else:
			curr_scale = MIN_SCALE  # Snap to original scale
			bubble_particles.set_emitting(false)	
	set_bubble_scale(curr_scale)

func get_bubble_scale() -> Vector2:
	return collision_shape.scale
	
func set_bubble_scale(new_scale: Vector2):
	collision_shape.scale = new_scale

func handle_horizontal_movement():
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
