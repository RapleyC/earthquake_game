extends State
class_name CharacterLocate

@export var character: CharacterBody2D
@export var move_speed := 50.0

var move_direction : Vector2
var move_angle : float
var wander_time : float
var direction_faced : String
var largest_key_value_pair: Array = [0, 0.0]
var base_time_to_locate: float
var adjusted_time_to_locate: float

const EARTHQUAKE_LOCATION_STATUS_BAR = preload("uid://beby013pqm8xx")

var progress_bar = EARTHQUAKE_LOCATION_STATUS_BAR.instantiate()
var earthquake_location_progress = 0


	
func earthquake_locate():
	base_time_to_locate = GlobalManager.earthquake_unlocated_catalog[0].magnitude ** 2
	adjusted_time_to_locate = base_time_to_locate - character.speed
	if adjusted_time_to_locate < 0:
		adjusted_time_to_locate = 0
	print("Time to locate ... " + str(adjusted_time_to_locate) + " seconds.")
	
	var progress_bar = EARTHQUAKE_LOCATION_STATUS_BAR.instantiate()
	var tween = create_tween()
	character.add_child(progress_bar)
	await tween.tween_property(progress_bar, "value", 100, adjusted_time_to_locate)
	await get_tree().create_timer(adjusted_time_to_locate).timeout
	character.current_experience += GlobalManager.earthquake_unlocated_catalog[0].magnitude
	progress_bar.queue_free()
	GlobalManager.earthquake_unlocated_catalog.remove_at(-1)
	print('Event located! '+str(len(GlobalManager.earthquake_unlocated_catalog))+" events left in the backlog.")
	Transitioned.emit(self, "CharacterIdle")
	

	
func enter():
	print('Begun locating!')
	earthquake_locate()
