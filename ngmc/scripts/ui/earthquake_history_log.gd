extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func earthquake_label_create():
	if len(GlobalManager.earthquake_catalog) == 0:
		return
	var my_label = Label.new()
	my_label.text = str(GlobalManager.earthquake_catalog[0]['magnitude'])
	add_child(my_label)
	print(str(GlobalManager.earthquake_catalog[0]['magnitude']))
