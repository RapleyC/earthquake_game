extends Node2D

@onready var global_timer: Label = $CanvasLayer/global_timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalManager.current_datetime = Time.get_datetime_string_from_system(false, true)
	GlobalManager.current_datetime_rounded = Time.get_datetime_string_from_system(false, true)
	GlobalManager.real_time_rounded_to_seconds = Time.get_unix_time_from_datetime_string(GlobalManager.current_datetime)

### Defines a base date/time string when the game is ran (YYYY-MM-DD HH:MM:SS) ###
						
func time_update():
	GlobalManager.real_time_rounded_to_seconds += (0.2)
	GlobalManager.current_datetime = Time.get_datetime_string_from_unix_time(GlobalManager.real_time_rounded_to_seconds, true)
	global_timer.text = GlobalManager.current_datetime
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(_delta: float) -> void:
	time_update()
