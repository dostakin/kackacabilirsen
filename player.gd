extends Area2D
signal hit

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var player_size

var touch_x_position
var touch_y_position
var touching
var first_touch_flag = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	player_size = $CollisionShape2D.shape.get_rect().size
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	var velocity = Vector2.ZERO # The player's movement vector
	if Input.is_action_pressed("move_right"):
			velocity.x += 1
	if Input.is_action_pressed("move_left"):
			velocity.x -= 1
	if Input.is_action_pressed("move_up"):
			velocity.y -= 1
	if Input.is_action_pressed("move_down"):
			velocity.y += 1
	
	# Stops movement by touch if player is too close to touched location
	if first_touch_flag:
		if player_size.x > abs($".".position.x - touch_x_position) and player_size.y > abs($".".position.y - touch_y_position + player_size.y*3):
			touching = false
	
	if touching:
		if touch_x_position > floor($".".position.x):
			velocity.x += 1
		if touch_x_position < floor($".".position.x):
			velocity.x -= 1
		if touch_y_position > floor($".".position.y + player_size.y*3):
			velocity.y += 1
		if touch_y_position < floor($".".position.y + player_size.y*3):
			velocity.y -= 1
	
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO+player_size*1.4, screen_size-player_size*1.4)
	
	$AnimatedSprite2D.flip_v = velocity.y > 0
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		# See the note below about the following boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"

# Mobile inputs
func _input(event):
	if event is InputEventScreenTouch:
		first_touch_flag = true
		if event.is_pressed():
			touching = true
			touch_x_position = event.get_position().x
			touch_y_position = event.get_position().y
		else:
			touching = false
	if event is InputEventScreenDrag:
		touching = true
		touch_x_position = event.get_position().x
		touch_y_position = event.get_position().y



func _on_body_entered(body):
	hide() # Player disappears after being hit
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
