extends Node2D

@export var projectile: PackedScene
@export var ammo: int
@export var ammo_capacity: int
@export var reload_time: int
@export var fire_rate: float
@export var semi_auto: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	ammo = ammo_capacity
	$FireRate.wait_time = fire_rate
	$FireRate.one_shot = true
	$ReloadTime.wait_time = reload_time
	$ReloadTime.one_shot = true
	$AnimatedSprite2D.play("idle")

func shoot():
	if ammo > 0 and $FireRate.is_stopped() and $ReloadTime.is_stopped():
		var new_projectile = projectile.instantiate()
		new_projectile.global_position = $Muzzle.global_position
		new_projectile.global_rotation = $Muzzle.global_rotation
		get_tree().root.add_child(new_projectile)
		$FireRate.start()
		ammo -= 1
		
func reload():
	$ReloadTime.start()
	$AnimatedSprite2D.play("reload")
	await $ReloadTime.is_stopped()
	ammo = ammo_capacity
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("idle")
		
