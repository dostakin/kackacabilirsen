extends Node

const LEVEL_SCORE_THRESHOLD = 5

@export var mob_scene: PackedScene
var score
var prev_level


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MobTimer.wait_time = 2
	prev_level = -2
	print($HUD/Message.modulate)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func game_over():
	$HUD/Message.modulate = Color(1,1,1,1)
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func new_game():
	get_tree().call_group("mobs", "queue_free")
	score = 0
	prev_level = -2
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Hazır ol!")
	$Music.play()

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)
	var level = floor(score/LEVEL_SCORE_THRESHOLD)-2
	$MobTimer.wait_time = 2 * (.8**level)
	if level > prev_level:
		prev_level = level
		$HUD/Message.modulate = Color(1,1,1,0.5)
		$HUD/Message.text = str("Level ", str(level+2), "\nDaha çok çıkıyorlar!")
		$HUD/Message.show()
		await get_tree().create_timer(1.0).timeout
		$HUD/Message.hide()

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene
	var mob = mob_scene.instantiate()
	# Choose a random location on Path2D
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	# Set the mob's direction perpendicular to the path direction
	var direction = mob_spawn_location.rotation + PI / 2
	
	# Set the mob's position to a random location
	mob.position = mob_spawn_location.position
	
	# Add some randomness to the direction
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Choose the velocity for the mob
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# Spawn the mob by adding it to the Main scene
	add_child(mob)
