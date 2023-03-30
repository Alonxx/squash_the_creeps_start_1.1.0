extends CharacterBody3D

# Minimum speed of the mob in meters per second.
@export var min_speed = 10
# Maximum speed of the mob in meters per second.
@export var max_speed = 18

signal squashed

func _physics_process(_delta):
	move_and_slide()


# This function will be called from the Main scene.
func initialize(start_position:Vector3, player_position:Vector3):
	# We position the mob by placing it at start_position
	# and rotate it towards player_position, so it looks at the player.
	look_at_from_position(start_position, player_position, Vector3.UP)
	# In this rotation^, the mob will move directly towards the player
	# so we rotate it randomly within range of -90 and +90 degrees.
	#ROTA DE FORMA RANDOM
	rotate_y(randf_range(-PI / 4, PI / 4))
	
	var random_speed:int = randi_range(min_speed,max_speed)
	
	# le decimos que se mueva
	velocity = Vector3.FORWARD * random_speed
	
	#NO SE QUE HACE ESTO, LE DECIMOS QUE ROTE PERO A DONDE??
	velocity = velocity.rotated(Vector3.UP,rotation.y)
	
	$AnimationPlayer.speed_scale = random_speed / min_speed

func squash():
	squashed.emit()
	queue_free()


func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()
