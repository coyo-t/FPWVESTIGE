function dwrt_cctv () begin
	with (obj_labyrinth_visuals) begin
		draw_push_state();
	
		cctv_surface_x    = surface_create_unexist(cctv_surface_x, RESW, RESH);
		cctv_surface_y    = surface_create_unexist(cctv_surface_y, RESW, RESH);
		cctv_surface_cube = surface_create_unexist(cctv_surface_cube, 512, 512);
	
		//var g = gpu_get_colourwriteenable();
		//gpu_set_colourwriteenable(1,1,1,1);
		surface_clear(cctv_surface_x, c_black);
		surface_clear(cctv_surface_y, c_black);
		surface_clear(cctv_surface_cube, c_black);
		//gpu_set_colourwriteenable(g[0],g[1],g[2],g[3]);
	
		if (obj_cctv.cctv_cam_garble_timer > 0)
		{
			draw_sprite_stretched_ext(
				spr_cctv_unknownError, time() * sprite_get_speed(spr_cctv_unknownError),
				0, 0, RESW, RESH,
				c_white, 1
			);
		
		} else {
			var sector = obj_cctv.cctv_current_sector_id;
			var sector = sector.sector_name;
		
			var sector_info = ds_map_exists(map_info, sector) 
				? map_info[? sector] 
				: -1;
			
			var sector_routine = ds_map_exists(sector_info, "draw_routine") 
				? sector_info[? "draw_routine"] 
				: -1;
		
			if (sector_routine != -1)
				script_execute(sector_routine, sector_info);
			else
				dwrt_cctv_none();
		
			//gpu_set_blendmode_ext(bm_dest_colour, bm_one);
			gpu_push_state();
		
			//draw the cam switch animation
			if (obj_cctv.cctv_cam_switch_timer >= 0)
			{
				gpu_set_blendmode(bm_normal);
				shader_set(sha_rgb_to_alpha);
				draw_sprite_stretched_ext(
					spr_cctv_switch, 
					(sprite_get_number(spr_cctv_switch) - 1) - obj_cctv.cctv_cam_switch_timer,
					0, 0, RESW, RESH,
					c_white, 1
				);
				shader_reset();
			}
		
			//draw static
			var stat_sprite = m_irandom(10) <= 2 ? spr_cctv_static_sep : spr_cctv_static;
			gpu_set_texfilter(false);
		
			var intense = obj_cctv.cctv_static_intensity;
			if (intense <= 255)
			{
				gpu_set_blendmode(bm_max);
				gpu_set_colourwriteenable(true, true, true, false);
	
				draw_sprite_stretched_ext(
					stat_sprite, time() * sprite_get_speed(stat_sprite),
					0, 0, RESW, RESH,
					make_colour_rgb(intense, intense, intense), 1
				);
			} else {
				draw_sprite_stretched(
					stat_sprite, time() * sprite_get_speed(stat_sprite),
					0, 0, RESW, RESH
				);
			}
			gpu_pop_state();
		
		}
	
		//additional draw routines pushed, ie ekka garble
		if (!ds_stack_empty(cctv_ads_dwrt_queue))
		{
			do
			{
				var routine = ds_stack_pop(cctv_ads_dwrt_queue);
				script_execute(routine);
			
			} until (ds_stack_empty(cctv_ads_dwrt_queue))
		
		}
	
		//haluc tim
		//probably dedicate this to its own object? shrug
		//if (keyboard_check(vk_backspace))
		//{
		//	dwrt_cctv_ekka_garble_1();
		//}
	
		draw_pop_state();

	end
end


function dwrt_cctv_placeholder () begin
	var cici = obj_chara_cici.parent_sector   == obj_cctv.cctv_current_sector_id.sector_name;
	var jakl = obj_chara_jakl.parent_sector   == obj_cctv.cctv_current_sector_id.sector_name;
	var grun = obj_chara_grun.parent_sector   == obj_cctv.cctv_current_sector_id.sector_name;
	var matt = obj_chara_mattis.parent_sector == obj_cctv.cctv_current_sector_id.sector_name;
	
	var px = 256;
	var py = 256;
	
	if (cici)
		draw_sprite(spr_t_room_cici, 0, px, py);
	if (jakl)
		draw_sprite(spr_t_room_jakl, 0, px, py);
	if (grun)
		draw_sprite(spr_t_room_grun, 0, px, py);
	if (matt)
		draw_sprite(spr_t_room_mattis, 0, px, py);
	
end


function dwrt_cctv_none () begin
	//draw_sprite(__spr_missing_wh, 0, 32, 32);
	draw_push_state();
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_text_colour(
		RESW/2, RESH/2, 
		"oops you fucked up",
		c_white, c_white,
		c_white, c_white,
		1.
	);

	draw_pop_state();

end


function dwrt_cctv_test () begin
	surface_resize(surface_x, 640, 480);
	surface_set_target(surface_x);
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
		camera_perspective,
		matrix_multiply(
			matrix_build_lookat(0,0,0, 0, 0, 1, 0, 1, 0),
			matrix_build(
				0, 0, 0,
				0, time() * 10, 0,
				1, 1, 1
			)
		)
	);

	camera_apply(camera_perspective);

	var cubetex = spr_cubemap_parallel_alpha;
	draw_cubemap_part(sprite_get_texture(cubetex, 0), 0, model_cubemap, 64);
	draw_cubemap_part(sprite_get_texture(cubetex, 1), 1, model_cubemap, 64);
	draw_cubemap_part(sprite_get_texture(cubetex, 2), 2, model_cubemap, 64);
	draw_cubemap_part(sprite_get_texture(cubetex, 3), 3, model_cubemap, 64);
	draw_cubemap_part(sprite_get_texture(cubetex, 4), 4, model_cubemap, 64);
	draw_cubemap_part(sprite_get_texture(cubetex, 5), 5, model_cubemap, 64);

	matrix_set(matrix_world, matrix_stack_top());
	gpu_pop_state();
	matrix_stack_pop();

	reset_camera_shit();


	surface_reset_target();
	gpu_set_texfilter(false);
	draw_surface_stretched(surface_x, 0, 0, RESW, RESH);

	var cc = __spr_cctv_test_hahahahaha;
	draw_sprite(cc, time() * sprite_get_speed(cc), RESW / 2, RESH / 2);



end


function dwrt_cctv_bedhall () begin
	var f = function (ind) begin
		switch (ind)
		{
			case 0: // left
				draw_sprite_stretched(spr_cubemap_placeholder, 0, 0, 0, 512, 512);
				return;
			case 1: // front
				draw_sprite_stretched(spr_cubemap_placeholder, 1, 0, 0, 512, 512);
				return;
			case 2: // right
				draw_sprite_stretched(spr_cubemap_placeholder, 2, 0, 0, 512, 512);
				return;
		}
	end

	dwrt_cubemap_switch([0, 1, 2], f, obj_cctv_cell_bedhall.camera);

	var s = __spr_cctv_test_hahahahaha;
	draw_sprite(s, sprite_get_speed(s) * time(), RESW*.5, (RESH*.5) + abs(sin(time() * sprite_get_speed(s) * .25) * 64));

	dwrt_cctv_placeholder();

end


function dwrt_cctv_hall_l () begin
	var f = function (ind) begin
		switch (ind)
		{
			case 1: // front
				draw_sprite_stretched(spr_cubemap_placeholder, 5, 0, 0, 512, 512);
				return;
			case 4: // top
				draw_sprite_stretched(spr_cubemap_placeholder, 4, 0, 0, 512, 512);
				return;
		
		}
	end
	
	dwrt_cubemap_switch([1, 4], f, obj_cctv_cell_hall_l.camera);
	
	dwrt_cctv_placeholder();
end


function dwrt_cctv_hall_r () begin
	var f = function (ind) begin
		switch (ind)
		{
			case 1: // front
				draw_sprite_stretched(spr_cubemap_placeholder, 5, 0, 0, 512, 512);
				return;
			case 4: // top
				draw_sprite_stretched(spr_cubemap_placeholder, 4, 0, 0, 512, 512);
				return;
		
		}
	end
	
	dwrt_cubemap_switch([1, 4], f, obj_cctv_cell_hall_r.camera);
	
	dwrt_cctv_placeholder();

end


function dwrt_cctv_main () begin
	//dwrt_cubemap_switch([0, 1, 2, 3, 5], scr_dwrt_cctv_main, obj_cctv_cell_main.camera);
	//gpu state nonsense aaaaa
	//yes i did copy this from draw_envmap shut up

	var f = function () begin
		var sect_cici = obj_chara_cici.current_sector;
		var sect_jakl = obj_chara_jakl.current_sector;
		var sect_grun = obj_chara_grun.current_sector;

		draw_sprite(spr_cctv_envmap_main, 0, 0, 0);

		var cici_main_4 = sect_cici == "main_3";
		var grun_main_4 = sect_grun == "main_3";

		if (sect_jakl == "main_1" || sect_jakl == "main_2")
			draw_sprite(spr_cctv_envmap_main_jakl_1, 0, 0, 0);


		if (sect_cici == "main_1")
			draw_sprite(spr_cctv_envmap_main_cici_1, 0, 0, 0);
	
		if (cici_main_4)
			draw_sprite(spr_cctv_envmap_main_cici_2, 0, 0, 0);
	
		if (sect_grun == "main_1" || (grun_main_4 && cici_main_4))
			draw_sprite(spr_cctv_envmap_main_grun_1, 0, 0, 0);
	
		if (grun_main_4 && !cici_main_4)
			draw_sprite(spr_cctv_envmap_main_grun_2, 0, 0, 0);

		if (sect_jakl == "main_3" || sect_jakl == "main_4")
			draw_sprite(spr_cctv_envmap_main_jakl_2, 0, 0, 0);
	end
	
	{ //draw the envmap
		var gpu_current = gpu_get_state();

		surface_resize(surface_x, 640, 480);
		surface_resize(surface_cube, 1024, 512);

		surface_set_target(surface_x); {

			draw_clear(c_black);
			gpu_set_state(gpu_current);
			surface_set_target(surface_cube); {
				draw_clear(c_black);
				f();
	
			} surface_reset_target();
	
			gpu_set_state(gpu_state_cube);
	
			camera_apply(obj_cctv_cell_main.camera);
			matrix_world_set(matrix_build_identity());
			vertex_submit(model_envmap, pr_trianglelist, surface_get_texture(surface_cube));
			matrix_world_reset();
			camera_apply(view_camera[view_current]);

			gpu_set_state(gpu_current);
	
		} surface_reset_target();

		gpu_set_texfilter(false);
		draw_surface_stretched(surface_x, 0, 0, RESW, RESH);
		ds_map_destroy(gpu_current);
	}
	
end


function dwrt_cctv_medi () begin
	var f = function (ind) begin
		switch (ind)
		{
			case 0: // left
				draw_sprite_stretched(spr_cubemap_placeholder, 0, 0, 0, 512, 512);
				return;
			case 1: // front
				draw_sprite_stretched(spr_cubemap_placeholder, 1, 0, 0, 512, 512);
				return;
			case 2: // right
				draw_sprite_stretched(spr_cubemap_placeholder, 2, 0, 0, 512, 512);
				return;
	
		}
	end
	
	dwrt_cubemap_switch([0, 1, 2], f, obj_cctv_cell_medi.camera);
	
	dwrt_cctv_placeholder();
end


function dwrt_cctv_bachta () begin
	var mati = obj_chara_mattis.current_sector == "bachta";

	draw_sprite(spr_cctv_cam_bachta, 0, 0, 0);

	if (mati) then
		draw_sprite(spr_cctv_cam_bachta, 1, 0, 0);

end


function dwrt_cctv_droid_start () begin
	draw_sprite(spr_cctv_cam_droid_enter, 0, 0, 0);

	if (obj_chara_cici.current_sector == "droid_start")
		draw_sprite(spr_cctv_cam_droid_enter, 1, 0, 0);
	
	if (obj_chara_jakl.current_sector == "droid_start")
		draw_sprite(spr_cctv_cam_droid_enter, 2, 0, 0);
	
	if (obj_chara_grun.current_sector == "droid_start")
		draw_sprite(spr_cctv_cam_droid_enter, 3, 0, 0);
		
end


function dwrt_cctv_interro () begin
	draw_push_state();
	draw_sprite_stretched_ext(
		spr_cctv_unknownError, time() * sprite_get_speed(spr_cctv_unknownError),
		0, 0, RESW, RESH,
		c_dkgrey, 1.
	);

	surface_cube = surface_create_unexist(surface_cube, 512, 512);

	surface_set_target(surface_cube);

	gpu_push_state();
	gpu_set_colourwriteenable(1,1,1,1);

	draw_clear_alpha(c_black, 0.);

	matrix_world_set(matrix_build(256, 256,0,0,time()*100,0,100,100,100));

	vertex_submit(obj_cctv_visuals.model_golem_symbol, pr_trianglelist, sprite_get_texture(tex_golem_symbol, 0));


	matrix_world_reset();

	gpu_pop_state();
	surface_reset_target();

	shader_set(sha_rBlur);
	shader_send("amount", 0.1);
	draw_surface_ext(surface_cube, RESW*.5 - 256, RESH*.5 - 256, 1, 1, 0, c_dkgrey, 1.);
	shader_reset();

	draw_set_halign(fa_center);
	draw_set_valign(fa_bottom);
	draw_set_font(_G.font_cc);
	draw_text_transformed(RESW*.5, RESH*.5, "Error, No signal\nexcept in nemmii", 1.5, 1.5, 0);

	draw_pop_state();

end


///@arg array
///@arg script
///@arg camera
function dwrt_cubemap_switch(arr, script, cam) begin
	//gpu state nonsense aaaaa
	var gpu_current = gpu_get_state();

	surface_resize(surface_x, 640, 480);
	surface_set_target(surface_x);
	draw_clear(c_black);

	begin
	var i = 0;

	repeat (array_size(arr))
	{
		gpu_set_state(gpu_current);
		surface_set_target(surface_cube);
		draw_clear(c_black);
		var ind = arr[i++];
	
		//normally a switch case goes here
		script(ind);
	
		surface_reset_target();
		gpu_set_state(gpu_state_cube);
		camera_apply(cam);
		draw_cubemap_part(surface_get_texture(surface_cube), ind, model_cubemap, 64);
	
		camera_apply(view_camera[view_current]);
	}
	end

	gpu_set_state(gpu_current);
	surface_reset_target();
	gpu_set_texfilter(false);
	draw_surface_stretched(surface_x, 0, 0, RESW, RESH);

	ds_map_destroy(gpu_current);

end

