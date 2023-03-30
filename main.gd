extends Node


@export var mob_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$UserInterface/Retry.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	mob_spawn_location.progress_ratio = randf()
	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position,player_position)
	add_child(mob)
	mob.squashed.connect($UserInterface/ScoreLabel._on_Mob_squashed.bind())

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()

func _on_player_hit():
	$MobTimer.stop()
	$UserInterface/Retry.show()
