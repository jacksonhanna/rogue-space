extends CharacterBody2D

@export var health: int
@export var speed: int
@export var jump_velocity: int
@export var attack_range: int
@export var reload_time: int
@export var agro_time: int
var direction: int = 1
var agro: bool = false
var player: CharacterBody2D

func _ready():
	player = get_tree().get_first_node_in_group("player")
	$ReloadTimer.wait_time = reload_time
	$AgroTimer.wait_time = agro_time

func _physics_process(delta):
	movement(delta)
	
	if not agro and $Area2D.has_overlapping_bodies():
		for body in $Area2D.get_overlapping_bodies():
			if body == player:
				agro = true
				$AgroTimer.start()
			 
	if agro:
		var player_distance = player.position.x - position.x
		direction = player_distance / abs(player_distance)
		if abs(player_distance) > attack_range:
			chase()
		else:
			attack()
		
	if health <= 0:
		die()
	
	animate()
	move_and_slide()
	
func movement(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	velocity.x = move_toward(velocity.x, 0, speed)

func chase():
	velocity.x = speed * direction
	
func jump():
	velocity.y = jump_velocity
	
func attack():
	if $ReloadTimer.is_stopped():
		$ReloadTimer.start()
		print("attack")
	
func damage(damage: int):
	health -= damage
	print(health)
	
func die():
	queue_free()

func animate():
	if direction > 0:
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false

func _on_agro_timer_timeout():
	agro = false
