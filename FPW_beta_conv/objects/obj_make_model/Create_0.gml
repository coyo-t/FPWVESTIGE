/// @desc
held_mouse_x = 0;
held_mouse_y = 0;
last_mouse_x = 0;
last_mouse_y = 0;
mouse_sens = 4;
mouse_move_state = -1;
mouse_coold = 0;

cam_pitch = 0;
cam_yaw = 0;
cam_roll  = 0;

cam_fov_x = 90;
cam_fov_y = 29.3577*2;

camera = camera_create();
//camera_set_proj_mat(
//	camera,
//	[
//		1., 0, 0, 0,
//		0, -1.78, 0, 0,
//		0, 0, 1, 1,
//		0, 0, -0.01, 0
//	]
//);
camera_set_proj_mat(
	camera,
	matrix_build_projection_perspective_fov(
		cam_fov_y, RESA, 0.01, 2400
	)
);
camera_set_view_mat(camera, LOOKFORWARDS);

surface = -1;

//cubemodel = model_load_vbm(BASEPATH+"mdl/envmap_segment.vbm", _G.vform_shadeless, true);

var modelName = "planetDiorama1";
//model = model_load_obj(DSKT + modelName + ".obj", _G.vform_shadeless);
//model = model_load_vbm(BASEPATH+"mdl/sphere_generic.vbm", _G.vform_shadeless, true);

//model = model_load_obj(DSKT+modelName+".obj", _G.vform_shadeless);
var opath = "D:/_projects/parallel2shit/obj/";
model = model_load_obj(opath+modelName+".obj", _G.vform_shadeless);
//model_off = model_load_vbm(BASEPATH+"mdl/plane.vbm", _G.vform_shadeless,false);

if (true)
{
	buffer_save(buffer_create_from_vertex_buffer(
		model, buffer_vbuffer, 1
	), opath + modelName + ".vbm");
}
//var str = "";
//var i = 1;
//repeat (256)
//{
//	var aaaa = i % 8 == 0 ? " // " + string(i) : "";
//	str += "\t" + string_format(random(1), 1, 8) + "," + aaaa + "\n";
//	++i;
//}

//clipboard_set_text(str);

d_surface1 = -1;
d_surface2 = -1;
