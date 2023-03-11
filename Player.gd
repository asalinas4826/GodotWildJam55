extends KinematicBody2D

const MOVE_SPEED = 100  # 500 px/s
const JUMP_FORCE = 400 # starting upwards velocity is 1000 pixels/second
const GRAVITY = 20		# acceleration rate
const MAX_FALL_SPEED = 300	# 1000 px/s
const PUSH = 5

# onready adds variables in _ready()
onready var sprite = $Sprite

var y_velo = 0
var facing_right = false

func _physics_process(delta):
	move()
	
func move():
	var move_dir = 0
	if Input.is_action_pressed("move_right"):
		move_dir += 1
	if Input.is_action_pressed("move_left"):
		move_dir -= 1
	# second Vector2 is the normal vector for floor you're on
	move_and_slide(Vector2(move_dir * MOVE_SPEED, y_velo), Vector2(0, -1), false, 4, 0.785398, false)
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider is Box:
			collision.collider.apply_central_impulse(-collision.normal * PUSH)
	
	var grounded = is_on_floor() # determines if on ground
	
	y_velo += GRAVITY
	if grounded and Input.is_action_pressed("jump"):
		y_velo = -JUMP_FORCE
	elif grounded and y_velo >= 5:
		y_velo = 5 # so that y_velo doesn't keep increasing due to gravity
		# also if y_velo = 0, is_on_floor() won't be triggered
	elif y_velo > MAX_FALL_SPEED:
		y_velo = MAX_FALL_SPEED
	if is_on_ceiling() and y_velo < 0:
		y_velo = 0
		
	if facing_right and move_dir < 0:
		flip()
	elif !facing_right and move_dir > 0:
		flip()
		
func flip() -> void:
	facing_right = !facing_right
	sprite.flip_h = !sprite.flip_h
	
