/// @desc
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

point_trans_w = 1280/2;
point_trans_h = 720/2;
point_trans_buff = buffer_create((point_trans_w * point_trans_h * 2), buffer_grow, 1);

var bff = point_trans_buff;

buffer_write(bff, buffer_u16, point_trans_w);
buffer_write(bff, buffer_u16, point_trans_h);

var srf = surface_create(point_trans_w, point_trans_h);
var srfbff = buffer_create(point_trans_w * point_trans_h * 4, buffer_grow, 1);

surface_set_target(srf); {
	draw_clear(c_black);
	var trans = matrix_get(matrix_world);
	camera_apply(camera);
	
	matrix_set(matrix_world, matrix_build_identity());
		
	shader_set(sha_dbg_uvs);
	vertex_submit(model, pr_trianglelist, sprite_get_texture(spr_null, 0));
	shader_reset();

	matrix_set(matrix_world, trans);
	camera_apply(camera_get_default());
} surface_reset_target();

buffer_get_surface(srfbff, srf, 0, 0, 0);
buffer_seek(bff, buffer_seek_start, 4);
buffer_seek(srfbff, buffer_seek_start, 0);

do {
	
	var xp = buffer_read(srfbff, buffer_u8);
	var yp = buffer_read(srfbff, buffer_u8);
	buffer_seek(srfbff, buffer_seek_relative, 1);
	buffer_seek(srfbff, buffer_seek_relative, 1);
	
	buffer_write(bff, buffer_u8, xp);
	buffer_write(bff, buffer_u8, yp);
	
} until (buffer_tell(srfbff) == buffer_get_size(srfbff))

buffer_delete(srfbff);
surface_free(srf);

buffer_save(bff, DSKT+"spheremap.lktb");
