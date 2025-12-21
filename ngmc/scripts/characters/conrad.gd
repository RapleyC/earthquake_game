extends CharacterBody2D

@export var speed = 200
var movement_animation: String
var direction: Vector2 = Vector2.ZERO


func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed

func _process(delta: float) -> void:
	get_input()
	move_and_slide()
