/// @desc
#region functions
function dist_pos () begin
	var pos = point_trans(
		meta_master.get_inp("mouse_x"), meta_master.get_inp("mouse_y"),
		lookup,
		RESW, RESH
	);

	pos[0] += camera_get_view_x(view_camera[view_current]);
	pos[1] += camera_get_view_y(view_camera[view_current]);

	return pos;

end


#endregion

surface = -1;
mdl_surface = -1;

cam_fov_x = 90;
cam_fov_y = 29.3577*2;

camera = camera_create();
camera_set_proj_mat(
	camera,
	matrix_build_projection_perspective_fov(
		cam_fov_y, RESA, 0.01, 2400
	)
);

model = model_load_vbm(BASEPATH+"mdl/fuck.vbm", _G.vform_shadeless, true);

lookup = buffer_load(BASEPATH+"spheremap.lktb");
