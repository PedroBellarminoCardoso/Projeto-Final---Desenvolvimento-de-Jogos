extends CharacterBody2D

@export var gravity: float = 900.0
@export var jump_force_multiplier: float = 4.0
@export var bounce_damping: float = 0.6

var can_jump: bool = true

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if velocity.y >= 0:
			can_jump = true

		velocity.x = move_toward(velocity.x, 0, 1000 * delta)

	move_and_slide()

	# 🔥 quicar sem grudar
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var normal = collision.get_normal()

		if velocity.dot(normal) < 0:
			velocity = velocity.bounce(normal) * bounce_damping


func launch(force: Vector2) -> void:
	if not is_on_floor():
		return
		
	if not can_jump:
		return

	velocity = force * jump_force_multiplier
	can_jump = false
