extends State
class_name CharacterWander

@export var character: CharacterBody2D
@export var move_speed := 50.0

var move_direction : Vector2
var move_angle : float
var wander_time : float
var direction_faced : String

@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	move_angle = rad_to_deg(move_direction.angle())+90
	if (move_angle >= -45 and move_angle < 0) or (move_angle >= 0 and move_angle < 45):
		direction_faced = "up"
	if (move_angle >= 225 and move_angle < 270) or (move_angle >= -90 and move_angle <= -45):
		direction_faced = "left"
	if (move_angle >= 45 and move_angle < 135):
		direction_faced = "right"
	if (move_angle >= 135 and move_angle < 225):
		direction_faced = "down"
	animated_sprite_2d.play("walk_"+direction_faced)
	wander_time = randf_range(1, 3)
		
func enter():
	print('Wandering')
	randomize_wander()

func update(delta: float):
	if len(GlobalManager.earthquake_unlocated_catalog) > 0:
		Transitioned.emit(self, "CharacterLocate")
	if wander_time > 0: 
		wander_time -= delta
	else:
		character.velocity = Vector2(0,0)
		animated_sprite_2d.play("idle_"+direction_faced)
		Transitioned.emit(self, "CharacterIdle")

func physics_update(_delta: float):	
	if character:
		character.velocity = move_direction * move_speed
