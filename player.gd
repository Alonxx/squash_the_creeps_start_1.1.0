extends CharacterBody3D



# How fast the player moves in meters per second.
@export var speed: int = 14
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration: int = 75

# Vertical impulse applied to the character upon jumping in meters per second.
@export var jump_impulse = 20

# Vertical impulse applied to the character upon bouncing over a mob in
# meters per second.
@export var bounce_impulse = 16

signal hit

var target_velocity: Vector3 = Vector3.ZERO

func _physics_process(delta):
	# We create a local variable to store the input direction.
	var direction: Vector3 = Vector3.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		# Notice how we are working with the vector's x and z axes.
		# In 3D, the XZ plane is the ground plane.		
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -=1
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		look_at(position + direction,Vector3.UP)
		$AnimationPlayer.speed_scale = 4
	else:
		$AnimationPlayer.speed_scale = 1
		
		
	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)		
		
	# Jumping.
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
		
	for index in range(get_slide_collision_count()):
		# We get one of the collisions with the player
		var collision = get_slide_collision(index)
		# If the collision is with ground
		if (collision.get_collider() == null):
			continue
			# If the collider is with a mob
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
				# we check that we are hitting it from above.
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				# If so, we squash it and bounce.
				mob.squash()
				target_velocity.y = bounce_impulse
		


		
	#Movin the character
	velocity = target_velocity
	move_and_slide()
	rotation.x = PI / 6 * velocity.y / jump_impulse
	
func die():
	hit.emit()
	queue_free()

func _on_mob_detector_body_entered(body):
	print(body)
	die()
