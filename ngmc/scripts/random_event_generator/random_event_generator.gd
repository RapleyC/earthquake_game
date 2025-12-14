extends Node

const EARTHQUAKE_RESOURCE = preload("uid://bpv8638cr3i5a")
var new_earthquake = EARTHQUAKE_RESOURCE.duplicate()
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.


func _ready() -> void:
	pass

func _on_timer_timeout() -> void:
	timer.wait_time = randf_range(1, 3)
	earthquake_trigger()

func aftershock_count_calculation(mainshock_magnitude):
	var aftershock_forecast_count = snapped(0.01 / ((1/mainshock_magnitude ** randf_range(2,4)) / randf_range(1,2)), 1)
	return aftershock_forecast_count
	
func generate_earthquake_magnitude():
	var rng = RandomNumberGenerator.new()
	var my_array = [randf_range(0,1), randf_range(1,2), randf_range(2,3), randf_range(3,4), 
					randf_range(4,5), randf_range(5,6), randf_range(6,7), randf_range(7,8), 
					randf_range(8,9), randf_range(9,10)]
	var weights = PackedFloat32Array([0.5, 1, 3, 1, 0.5, 0.1, 0.05, 0.01, 0.005, 0.001])
	return snapped(my_array[rng.rand_weighted(weights)], 0.01)

func earthquake_trigger():
	if randf_range(0,100) > 0:
		new_earthquake.date_time = GlobalManager.current_datetime
		new_earthquake.magnitude = generate_earthquake_magnitude()
		new_earthquake.depth = snapped(randf_range(0, 70), 0.01)
		new_earthquake.latitude = snapped(randf_range(-90, 90), 0.01)
		new_earthquake.longitude = snapped(randf_range(-180, 180), 0.01)
		var earthquake_id: int = 1 + len(GlobalManager.earthquake_catalog)
		GlobalManager.earthquake_catalog.push_front({"unique_id" : str(earthquake_id),
													"date_time": GlobalManager.current_datetime,
													"magnitude": new_earthquake.magnitude,
													"depth": new_earthquake.depth,
													"latitude": new_earthquake.latitude,
													"longitude": new_earthquake.longitude,
													"location": ""})
		print("TIME: " + str(GlobalManager.current_datetime) + " Event ID: " + str(earthquake_id) + " (MAIN SHOCK). Magnitude: " + str(new_earthquake.magnitude) + " Depth: " + str(new_earthquake.depth) + "km")
		aftershock_sequence(earthquake_id, new_earthquake.magnitude, new_earthquake.depth, new_earthquake.latitude, new_earthquake.longitude)
			
func aftershock_sequence(input_earthquake_id, input_mainshock_magnitude, input_mainshock_depth, input_mainshock_latitude, input_mainshock_longitude):
	var aftershock_count = aftershock_count_calculation(input_mainshock_magnitude)
	while aftershock_count != 0:
		await get_tree().create_timer(randf_range(1,3)).timeout
		if randf_range(0,100) > 0:
			var magnitude = randf_range(-1,input_mainshock_magnitude-1)
			var earthquake_id: int = 1 + len(GlobalManager.earthquake_catalog)
			var earthquake_depth: float = randf_range(input_mainshock_depth - (input_mainshock_depth/10), input_mainshock_depth + (input_mainshock_depth/10))
			var earthquake_latitude: float = randf_range(input_mainshock_latitude - (1/20 * input_mainshock_magnitude), input_mainshock_latitude + (1/20 * input_mainshock_magnitude))
			var earthquake_longitude: float = randf_range(input_mainshock_longitude - (1/20 * input_mainshock_magnitude), input_mainshock_longitude + (1/20 * input_mainshock_magnitude))
			GlobalManager.earthquake_catalog.push_front({"unique_id" : str(earthquake_id),
														"date_time": GlobalManager.current_datetime,
														"magnitude": new_earthquake.magnitude,
														"depth": new_earthquake.depth,
														"latitude": new_earthquake.latitude,
														"longitude": new_earthquake.longitude,
														"location": ""})
			aftershock_sequence(earthquake_id, magnitude, earthquake_depth, earthquake_latitude, earthquake_longitude)
			print("TIME: " + str(GlobalManager.current_datetime) + " Event ID: " + str(earthquake_id) + " (AFTERSHOCK OF " + str(input_earthquake_id) + "). Magnitude: " + str(new_earthquake.magnitude) + " Depth: " + str(new_earthquake.depth) + "km")
			aftershock_count -= 1
			if aftershock_count == 0:
				return			
			
