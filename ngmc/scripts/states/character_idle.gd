extends State
class_name CharacterIdle

@export var character: CharacterBody2D
@export var idle_time: float = 5.0

func randomize_idle_time():
	idle_time = randf_range(4.0, 15.0)

func enter():
	print('Idling')
	character.velocity = Vector2(0,0)
	randomize_idle_time()

func update(delta: float):
	if len(GlobalManager.earthquake_unlocated_catalog) > 0:
		Transitioned.emit(self, "CharacterLocate")
	if idle_time > 0: 
		idle_time -= delta
	else:
		Transitioned.emit(self, "CharacterWander")
