/// @desc
draw_clear(c_dkgrey);
gpu_push_state();
gpu_set_cullmode(cull_noculling)
gpu_set_texrepeat(false);
gpu_set_texfilter(true);

matrix_stack_push(matrix_get(matrix_world));
matrix_set(
	matrix_world,
	matrix_build(
		mouse_x_real(), mouse_y_real(), 0, 
		0, time() * 45, 0,
		128, 128, 128
	)
);

vertex_submit(model, pr_trianglelist, sprite_get_texture(spr_envmap_test, 0));

matrix_set(matrix_world, matrix_stack_top());
matrix_stack_pop();
gpu_pop_state();

#region wut
/*
d_surface1 = surface_create_unexist(d_surface1, 128, 128);
d_surface2 = surface_create_unexist(d_surface2, 512, 256);

surface_set_target(d_surface1);
draw_clear(c_red);
surface_set_target(d_surface2);
draw_clear(c_black);
draw_sprite(spr_navball, 0, 0, 0);
draw_sprite(spr_ekka_legacy, 0, (time() * 59) mod 512, 128);
surface_reset_target();
draw_clear(c_fuchsia)
surface_reset_target();

draw_clear(c_black);
gpu_push_state();
gpu_set_cullmode(cull_clockwise);
gpu_set_texrepeat(false);
gpu_set_texfilter(true);

matrix_stack_push(matrix_get(matrix_world));
matrix_set(
	matrix_world,
	matrix_build(
		0, 0, 0, 
		0, 0, 0,
		128, 128, 128
	)
);

camera_set_view_mat(
	camera,
	matrix_multiply(
		LOOKFORWARDS,
		matrix_build(
			0, 0, 0,
			-cam_pitch, cam_yaw, cam_roll,
			1, 1, 1
		)
	)
);

camera_apply(camera);
shader_set(sha_model);
var cubetex = spr_cubemap_minecraft_1;
draw_cubemap_part(sprite_get_texture(cubetex, 0), 0, cubemodel, 6);
draw_cubemap_part(sprite_get_texture(cubetex, 1), 1, cubemodel, 6);
draw_cubemap_part(sprite_get_texture(cubetex, 2), 2, cubemodel, 6);
draw_cubemap_part(sprite_get_texture(cubetex, 3), 3, cubemodel, 6);
draw_cubemap_part(sprite_get_texture(cubetex, 4), 4, cubemodel, 6);
draw_cubemap_part(sprite_get_texture(cubetex, 5), 5, cubemodel, 6);

gpu_set_blendmode(bm_add);
draw_set_model_alpha(0.25);
var mat = matrix_get(matrix_world);
matrix_multiply_world(matrix_build(0,0,0,0,0,0,.9,.9,.9));

//draw_cubemap_sprite(spr_cubemap_placeholder, cubemodel);

matrix_set(matrix_world, mat);

//draw_set_model_colour($0a0a0a);
//gpu_set_blendmode(bm_max);
//matrix_set(
//	matrix_world,
//	matrix_build(
//		0, 0, 0, 
//		0, 0, 0,
//		-.5, .5, .5
//	)
//);

//vertex_submit(model, pr_trianglelist, sprite_get_texture(spr_navball, 0));

draw_set_model_alpha(0.5);
draw_set_model_colour(c_white);

gpu_set_blendmode(bm_normal);

camera_apply(view_camera[0]);

matrix_set(
	matrix_world,
	matrix_build(
		0, 0, 0,
		-cam_pitch, cam_yaw, cam_roll,
		115, 115, 115
	)
);

matrix_multiply_world(matrix_build(0, 0, 0, 0, 0, 0, 1, .5, 1));
matrix_multiply_world(matrix_build(room_width/2, room_height - 115, 0, 0, 0, 0, 1, 1., 1));

vertex_submit(model, pr_trianglelist, surface_get_texture(d_surface2));

draw_set_model_alpha(1.);
matrix_set(matrix_world, matrix_stack_top());
gpu_pop_state();
matrix_stack_pop();
shader_reset();

camera_apply(view_camera[0]);
draw_surface(d_surface1, meta_master.input[?"mouse_x"], meta_master.input[?"mouse_y"]);
draw_surface(d_surface2, room_width-meta_master.input[?"mouse_x"], room_height-meta_master.input[?"mouse_y"]);

//todo, just make cubemaps 6 individual planes that are each drawn with a power of 2 tex
//sprite with 6 subimages?
*/
#endregion