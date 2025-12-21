extends Node

const EARTHQUAKE_RESOURCE = preload("uid://bpv8638cr3i5a")
var new_earthquake = EARTHQUAKE_RESOURCE.duplicate()

@onready var earthquake_generation_timer: Timer = $earthquake_generation_timer
@onready var v_box_container: VBoxContainer = $"../CanvasLayer/ScrollContainer/VBoxContainer"
@onready var scroll_container: ScrollContainer = $"../CanvasLayer/ScrollContainer"

### variable timers that triggers the mainshock generation function on timeout ###
func _on_timer_timeout() -> void:
	earthquake_generation_timer.wait_time = randf_range(0.5, 3)
	earthquake_trigger()
			
func earthquake_label_creation(id, datetime, magnitude, depth, coordinate):
	var negative_magnitude_space = " "
	if magnitude < 0:
		negative_magnitude_space = ""
	var depth_space_before = "  "
	if depth >= 10 and depth < 100:
		depth_space_before = " "
	if depth >= 100:
		depth_space_before = ""
	var label_tween = create_tween()
	var new_earthquake_label = Label.new()

	new_earthquake_label.text = str(str("%03d"%id)+str("%10s"%"M"+negative_magnitude_space+"%.2f"%magnitude)+str("%10s"%depth_space_before+"%.2f"%depth+"km"))
	new_earthquake_label.add_theme_font_size_override("font_size", 16)
	v_box_container.add_child(new_earthquake_label)
	v_box_container.move_child(new_earthquake_label, 0)
	label_tween.tween_property(new_earthquake_label, "modulate:a", 0, 0)
	label_tween.tween_property(new_earthquake_label, "modulate:a", 1, 0.5)
	label_tween.tween_property(new_earthquake_label, "modulate:a", 1, 29)
	label_tween.tween_property(new_earthquake_label, "modulate:a", 0, 0.5)
	await get_tree().create_timer(20.0).timeout
	new_earthquake_label.queue_free()
	
### When a mainshock or aftershock occurs, determines the amount of aftershocks it will generate ###
#func aftershock_count_calculation(mainshock_magnitude):
#	var aftershock_forecast_count = snapped(0.01 / ((1/mainshock_magnitude ** randf_range(2,4)) / randf_range(1,2)), 1)
#	return aftershock_forecast_count
	
### for each mainshock, generates a random weighted magnitude ###
func generate_earthquake_magnitude():
	var rng = RandomNumberGenerator.new()
	var my_array = [randf_range(0,1), randf_range(1,2), randf_range(2,3), randf_range(3,4), 
					randf_range(4,5), randf_range(5,6), randf_range(6,7), randf_range(7,8), 
					randf_range(8,9), randf_range(9,10)]
	var weights = PackedFloat32Array([0.1, 0.5, 1, 0.5, 0.1, 0.05, 0.01, 0.005, 0.001, 0.0005])
	return snapped(my_array[rng.rand_weighted(weights)], 0.01)

### when an earthquake is generated, creates unique id, magnitude, depth, coordinates, and saves to database ###
func earthquake_trigger():
	if randf_range(0,100) > 0:
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
													"is_located": false})
		GlobalManager.earthquake_unlocated_catalog.push_front({"unique_id" : new_earthquake.id,
													"date_time": GlobalManager.current_datetime,
													"magnitude": new_earthquake.magnitude,
													"depth": new_earthquake.depth,
													"coordinates": new_earthquake.coordinates,
													"is_located": false})
		earthquake_label_creation(new_earthquake.id, GlobalManager.current_datetime, new_earthquake.magnitude, new_earthquake.depth, new_earthquake.coordinates)
		print(str(len(GlobalManager.earthquake_catalog))+"     " +str(len(GlobalManager.earthquake_unlocated_catalog)))
		
