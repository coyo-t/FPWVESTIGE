mats = fpw.trans;
gs = obj_main_night_fps_test.gamestate;

entities = [];
grab_mouse = false;

// ----

function rebuild_proj_mat (_fov)
{
	mat_3d_proj = matrix_build_projection_perspective_fov(
		fov_h2v(_fov, appsurf_w, appsurf_h),
		appsurf_w / appsurf_h,
		0.01,
		20000
	);
}

mat_3d_view = identity_matrix;
mat_3d_proj = identity_matrix;
rebuild_proj_mat(fov);
