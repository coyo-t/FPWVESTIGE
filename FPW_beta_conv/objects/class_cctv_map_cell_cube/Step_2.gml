/// @desc
if (!cctv_object.is_cctv_on) { exit; }

if (is_active)
{	
	if (loop_pitch) { camera_pitch %= 360; } else
	{
		camera_pitch = clamp(camera_pitch, camera_pitch_min, camera_pitch_max);
	}
	
	if (loop_yaw) { camera_yaw %= 360; } else
	{
		camera_yaw = clamp(camera_yaw, camera_yaw_min, camera_yaw_max);
	}

	camera_set_view_mat(
		camera,
		matrix_multiply(
			LOOKFORWARDS,
			matrix_build(
				0,0,0,
				camera_pitch,
				camera_yaw,
				camera_roll,
				1,1,1
			)
		)
	);
	
	
	if (camera_fov != camera_fov_last)
	{
		camera_set_proj_mat(
			camera,
			matrix_build_projection_perspective_fov(
				fov_h2v(camera_fov, RESW, RESH), RESA, ZNEAR, ZFAR
			)
		);
	}
	
}

camera_fov_last = camera_fov;
