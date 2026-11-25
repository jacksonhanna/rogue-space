extends Node2D

@export var damage: int
@export var speed: int

func _ready():
	$Area2D.body_entered.connect(_on_area_body_entered)

func _process(delta):
	for bullet in get_children():
		bullet.position.x += delta * speed * cos(bullet.rotation)
		bullet.position.y += delta * speed * sin(bullet.rotation)
		

func _on_area_body_entered(body):
	if body.is_in_group("enemy"):
		body.damage(damage)
	queue_free()
	if get_parent().get_child_count() == 1:
		get_parent().queue_free()
