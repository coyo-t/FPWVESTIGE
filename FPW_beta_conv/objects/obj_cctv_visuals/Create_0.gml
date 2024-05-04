/// @desc
surface_x    = -1;
surface_y    = -1;
surface_cube = -1;

dwrt_queue = ds_stack_create(); //additional draw routines

model_cubemap = model_load_vbm(BASEPATH+"mdl/envmap_segment.vbm", _G.vform_shadeless, true);
model_envmap  = model_load_vbm(BASEPATH+"mdl/envmap.vbm", _G.vform_shadeless, true);
model_golem_symbol = model_load_vbm(BASEPATH+"mdl/golem_symbol_3d.vbm", _G.vform_shadeless, true);

gpu_push_state();
gpu_set_cullmode(cull_clockwise);
gpu_set_texrepeat(false);
gpu_set_texfilter(true);

gpu_state_cube = gpu_get_state();
gpu_pop_state();

//shit
cam_fov_x = 90;
cam_fov_y = 29.3577*2;

camera_no_offset = camera_create_view(0, 0, RESW, RESH);

camera_perspective = camera_create();
camera_set_proj_mat(
	camera_perspective,
	matrix_build_projection_perspective_fov(
		cam_fov_y, RESA, 0.01, 2400
	)
);
