extends CharacterBody2D

enum STATE {ACTIVE, PASSIVE}

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var selected_weapon_index = 0
var selected_weapon: Node
@export var current_state: STATE

func _ready():
	selected_weapon = $Weapons.get_children()[selected_weapon_index]

func _physics_process(delta):
	
	movement(delta)
	weapon()
	animate()

	move_and_slide()

func movement(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func weapon():
	if current_state == STATE.ACTIVE:
		selected_weapon.look_at(get_global_mouse_position())
		selected_weapon.rotation_degrees = fmod(selected_weapon.rotation_degrees, 360.0)
		
		if selected_weapon.semi_auto:
			if Input.is_action_just_pressed("shoot"):
				selected_weapon.shoot()
		else:
			if Input.is_action_pressed("shoot"):
				selected_weapon.shoot()
			
		if Input.is_action_just_pressed("reload"):
			selected_weapon.reload()
		
		if Input.is_action_just_pressed("switch_weapon"):
			selected_weapon_index = selected_weapon_index + 1 if selected_weapon_index != $Weapons.get_child_count() - 1 else 0
			selected_weapon = $Weapons.get_children()[selected_weapon_index]

func animate():
	if current_state == STATE.ACTIVE:
		if abs(selected_weapon.rotation_degrees) < 270.0 and abs(selected_weapon.rotation_degrees) > 90.0:
			$Sprite2D.flip_h = true
			selected_weapon.find_child("AnimatedSprite2D").flip_v = true
		else:
			$Sprite2D.flip_h = false
			selected_weapon.find_child("AnimatedSprite2D").flip_v = false
	else:
		if Input.is_action_just_pressed("move_left"):
			$Sprite2D.flip_h = true
		elif Input.is_action_just_pressed("move_right"):
			$Sprite2D.flip_h = false
			
	for weapon in $Weapons.get_children():
		if weapon == selected_weapon and current_state == STATE.ACTIVE:
			weapon.show()
		else:
			weapon.hide()
