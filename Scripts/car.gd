extends VehicleBody3D

const MAX_STEER = 0.8
const ENGINE_POWER = 300

@onready var camera_pivot = $CameraPivot
@onready var camera_3d = $CameraPivot/FrontCamera
@onready var reverse_camera = $CameraPivot/ReverseCamera

var looking_at

# Called when the node enters the scene tree for the first time.
func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	looking_at = global_position
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	steering = move_toward(steering, Input.get_axis("ui_right", "ui_left") * MAX_STEER, delta * 2.5)
	engine_force = Input.get_axis("ui_down", "ui_up") * ENGINE_POWER
	camera_pivot.global_position = camera_pivot.global_position.lerp(global_position, delta * 20.0)
	camera_pivot.transform = camera_pivot.transform.interpolate_with(transform, delta * 5.0)
	looking_at = looking_at.lerp(global_position + linear_velocity, delta * 5.0)
	camera_3d.look_at(looking_at)
	reverse_camera.look_at(looking_at)
	_check_camera_switch()

func _check_camera_switch():
	var forward_speed = linear_velocity.dot(transform.basis.z)
	if forward_speed > 1.0:
		camera_3d.current = true
	elif forward_speed < -1.0:
		reverse_camera.current = true
