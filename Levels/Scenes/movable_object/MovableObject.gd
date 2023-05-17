extends KinematicBody2D
class_name MovableObject

var default_position
export var direction : Vector2
export var max_distance : float
export var force_toward_default : float
var velocity : Vector2

func _ready() -> void:
	default_position = position
	direction = direction.normalized()

#push the movable object along its direction
func push_object(impulse : Vector2) :
	velocity = impulse.project(direction)


func _physics_process(delta: float) -> void:
	if (position - default_position).dot(direction) < 0 :
		position = default_position
		velocity = Vector2.ZERO
	else :
		if (position - default_position).dot(direction) > max_distance :
			velocity = - 100*force_toward_default * direction
			move_and_collide(velocity)
		if !(default_position == position and velocity == Vector2.ZERO) :
			velocity = - force_toward_default * direction
			move_and_collide(velocity)
