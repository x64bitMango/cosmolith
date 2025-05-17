extends RigidBody3D

var mouse_sensitivity := 0.005
var pitch_limit := deg_to_rad(89.0) # prevent flipping
var pitch := 0.0

@onready var yaw_node: Node3D = $Yaw
@onready var pitch_node: Node3D = $Yaw/Pitch

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(delta: float) -> void:
	# Movement input
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")
	
	# Transform direction to local basis
	var direction = (yaw_node.transform.basis * input).normalized()
	apply_central_force(direction * 1300.0 * delta)

	# Escape to show mouse
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			# Yaw (left/right)
			yaw_node.rotate_y(-event.relative.x * mouse_sensitivity)

			# Pitch (up/down)
			pitch -= event.relative.y * mouse_sensitivity
			pitch = clamp(pitch, -pitch_limit, pitch_limit)
			pitch_node.rotation.x = pitch
