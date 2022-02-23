extends Spatial

var locked = true

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	load_transform()

func save_transform():
	var file = File.new()
	file.open("res://camera_transform.json", File.WRITE)
	file.store_var(transform)
	file.close()
	
		
func load_transform():
	var file = File.new()
	if(file.file_exists("res://camera_transform.json")):
		file.open("res://camera_transform.json", File.READ)
		var transf := file.get_var() as Transform
		file.close()
		transform = transf
		
	
func _input(event):
	if event is InputEventMouseMotion:
		if locked:
			var rot = Vector3(event.relative.y, event.relative.x, 0)
			rotation_degrees.x -= rot.x * 0.3
			rotation_degrees.x = clamp(rotation_degrees.x, -33.0, 70.0)
			rotation_degrees.y -= rot.y * 0.3
		
		
	if Input.is_action_pressed("capture_transform"):
		save_transform()
		
	if Input.is_action_just_released("lock_view"):
		locked = !locked
		if locked:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var up_down = (1.0 if Input.is_action_pressed("ui_space_up") else 0.0) + (-1.0 if Input.is_action_pressed("ui_ctrl_down") else 0.0)
	var input_3d = Vector3(input.x, up_down, input.y)
	
	transform = transform.translated(input_3d * 0.2)
