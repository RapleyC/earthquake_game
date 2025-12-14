extends Node

const EARTHQUAKE_RESOURCE = preload("uid://bpv8638cr3i5a")
var new_earthquake = EARTHQUAKE_RESOURCE.duplicate()
@onready var earthquake_generation_timer: Timer = $earthquake_generation_timer

### variable timers that triggers the mainshock generation function on timeout ###
func _on_timer_timeout() -> void:
	earthquake_generation_timer.wait_time = randf_range(0.5, 3)
	earthquake_trigger()

### When a mainshock or aftershock occurs, determines the amount of aftershocks it will generate ###
func aftershock_count_calculation(mainshock_magnitude):
	var aftershock_forecast_count = snapped(0.01 / ((1/mainshock_magnitude ** randf_range(2,4)) / randf_range(1,2)), 1)
	return aftershock_forecast_count
	
### for each mainshock, generates a random weighted magnitude ###
func generate_earthquake_magnitude():
	var rng = RandomNumberGenerator.new()
	var my_array = [randf_range(0,1), randf_range(1,2), randf_range(2,3), randf_range(3,4), 
					randf_range(4,5), randf_range(5,6), randf_range(6,7), randf_range(7,8), 
					randf_range(8,9), randf_range(9,10)]
	var weights = PackedFloat32Array([0.1, 0.5, 1, 0.5, 0.1, 0.05, 0.01, 0.005, 0.001, 0.0005])
	return snapped(my_array[rng.rand_weighted(weights)], 0.01)

### when an earthquake is generated, creates unique id, magnitude, depth, coordinates, and location information and saves to database ###
### also generates aftershocks as applicable ###
func earthquake_trigger():
	if randf_range(0,100) > 90:
		new_earthquake.id = 1 + len(GlobalManager.earthquake_catalog)
		new_earthquake.date_time = GlobalManager.current_datetime
		new_earthquake.magnitude = generate_earthquake_magnitude()
		new_earthquake.depth = snapped(randf_range(0, 70), 0.01)
		new_earthquake.coordinates = Vector2(snapped(randf_range(-90, 90), 0.01), snapped(randf_range(-180, 180), 0.01))
		GlobalManager.earthquake_catalog.push_front({"unique_id" : new_earthquake.id,
													"date_time": GlobalManager.current_datetime,
													"magnitude": new_earthquake.magnitude,
													"depth": new_earthquake.depth,
													"coordinates": new_earthquake.coordinates,
													"location": ""})
		print("TIME: " + str(GlobalManager.current_datetime) + " Event ID: " + str(new_earthquake.id) + " (MAIN SHOCK). Magnitude: " + str(new_earthquake.magnitude) + " Depth: " + str(new_earthquake.depth) + "km")
		aftershock_sequence(new_earthquake.id, new_earthquake.magnitude, new_earthquake.depth, new_earthquake.coordinates)

### generates aftershock sequence based off mainshock magnitude ###
func aftershock_sequence(input_earthquake_id, input_mainshock_magnitude, input_mainshock_depth, input_mainshock_coordinates):
	var aftershock_count = aftershock_count_calculation(input_mainshock_magnitude)
	while aftershock_count != 0:
		await get_tree().create_timer(randf_range(0.5,3)).timeout
		if randf_range(0,100) > 75:
			new_earthquake.magnitude = snapped(randf_range(-1,input_mainshock_magnitude-1), 0.01)
			new_earthquake.id = 1 + len(GlobalManager.earthquake_catalog)
			new_earthquake.depth = snapped(randf_range(input_mainshock_depth - (input_mainshock_depth/10), input_mainshock_depth + (input_mainshock_depth/10)), 0.01)
			new_earthquake.coordinates = Vector2(randf_range(input_mainshock_coordinates.y - (1/20 * input_mainshock_magnitude), input_mainshock_coordinates.y + (1/20 * input_mainshock_magnitude)), randf_range(input_mainshock_coordinates.x - (1/20 * input_mainshock_magnitude), input_mainshock_coordinates.x + (1/20 * input_mainshock_magnitude)))
			GlobalManager.earthquake_catalog.push_front({"unique_id" : new_earthquake.id,
														"date_time": GlobalManager.current_datetime,
														"magnitude": new_earthquake.magnitude,
														"depth": new_earthquake.depth,
														"coordinates": new_earthquake.coordinates,
														"location": ""})
			if randf_range(0,100) > 75:
				aftershock_sequence(new_earthquake.id, new_earthquake.magnitude, new_earthquake.depth, new_earthquake.coordinates)
			print("TIME: " + str(GlobalManager.current_datetime) + " Event ID: " + str(new_earthquake.id) + " (AFTERSHOCK OF " + str(input_earthquake_id) + "). Magnitude: " + str(new_earthquake.magnitude) + " Depth: " + str(new_earthquake.depth) + "km")
			aftershock_count -= 1
			if aftershock_count == 0:
				return			
			
