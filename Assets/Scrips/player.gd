extends CharacterBody3D

@export var speed: float = 5
@export var rotation_speed: float = 10

@onready var visuals: Node3D = $Visuals
@onready var camera: Camera3D = $CameraPivot/Camera3D

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float) -> void:
	#get a player input
	var input_dir := Input.get_vector(
		"ui_right",
		"ui_left",
		"ui_up",
		"ui_down"
	)
	
	var forward := -camera.global_basis.z
	var right := camera.global_basis.x
	
	forward.y = 0
	right.y =0
	
	forward = forward.normalized()
	right = right.normalized()
	
	var direction := right * input_dir.x - forward * input_dir.y
	direction = direction.normalized()
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	if direction.length() > 0.1:
		var target_angle := atan2(-direction.x, -direction.z)
		visuals.rotation.y = lerp_angle(
			visuals.rotation.y,
			target_angle,
			rotation_speed * delta
		)
		
	move_and_slide()
