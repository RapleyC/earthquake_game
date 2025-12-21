extends CharacterBody2D
class_name Kelvin

@onready var label_name: Label = $label_name

var level: int = 1
var current_experience: int = 0
var maximum_experience: int = 50
var speed: int = 1

func _ready():
	var label_tween = create_tween()
	label_tween.tween_property(label_name, "modulate:a", 0, 0)
	
func _physics_process(delta: float) -> void:
	move_and_slide()
	level_up()
	
func level_up():
	if current_experience >= maximum_experience:
		print('Level up!')
		level +=1 
		current_experience = maximum_experience - current_experience
		maximum_experience *= 1.3
		speed += (level*0.7)

func _on_mouse_over_area_mouse_entered() -> void:
	var label_tween = create_tween()
	label_tween.tween_property(label_name, "modulate:a", 1, 0.25)

func _on_mouse_over_area_mouse_exited() -> void:
	var label_tween = create_tween()
	label_tween.tween_property(label_name, "modulate:a", 0, 0.25)
