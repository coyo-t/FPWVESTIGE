/// @desc

// Inherit the parent event
event_inherited();

camera = camera_create();
camera_roll     = 0;
camera_fov_last = camera_fov;

camera_set_proj_mat(
	camera,
	matrix_build_projection_perspective_fov(
		fov_h2v(camera_fov, RESW, RESH), RESA, ZNEAR, ZFAR
	)
);
camera_set_view_mat(camera, LOOKFORWARDS);

