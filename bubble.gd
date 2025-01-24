extends CharacterBody2D
@export var num : float
@export var blowdown_curve: Curve

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ORIGINAL_SCALE_SPEED = 2.0
const ORIGINAL_SCALE = Vector2(1.0, 1.0)  # Original scale of the object
const MAX_SCALE = Vector2(1.0, 1.0) * 5  # Original scale of the object
const MIN_SCALE = Vector2(1.0, 1.0) * 0.3
const SCALE_SPEED = 2.0  # Speed of scaling
var TARGET_SCALE = scale  # Target scale when key is pressed
var is_scaling_up = false  # Whether the object is scaling up

var upwards_force := 0.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("ui_accept"):
		is_scaling_up = true
		TARGET_SCALE = TARGET_SCALE * 1.2
		if TARGET_SCALE > MAX_SCALE:
			TARGET_SCALE = MAX_SCALE
	
	if is_scaling_up:
		scale = scale.slerp(TARGET_SCALE, SCALE_SPEED * delta)
		if scale.distance_to(TARGET_SCALE) < 0.01:
			scale = TARGET_SCALE  # Snap to target scale
			is_scaling_up = false
	else:
		if scale > ORIGINAL_SCALE:
			var multiplier = 1.0 / (ORIGINAL_SCALE.distance_to(scale) / ORIGINAL_SCALE.distance_to(MAX_SCALE))
			scale = scale.lerp(ORIGINAL_SCALE, SCALE_SPEED * delta * multiplier)
		else:
			scale = ORIGINAL_SCALE  # Snap to original scale
			
	upwards_force = scale.length()
	velocity.y -= upwards_force * 10
	
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal()) * 0.5
		
	#move_and_slide()
