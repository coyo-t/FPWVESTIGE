/// @desc

draw_push_state();
var map_info = obj_labyrinth_visuals.map_info;

surface_x    = surface_create_unexist(surface_x, RESW, RESH);
surface_y    = surface_create_unexist(surface_y, RESW, RESH);
surface_cube = surface_create_unexist(surface_cube, 512, 512);

if (surface_get_width(surface_cube) != 512 || surface_get_height(surface_cube) != 512)
	surface_resize(surface_cube, 512, 512);

surface_clear(surface_x, c_black);
surface_clear(surface_y, c_black);
surface_clear(surface_cube, c_black);
	
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
		gpu_set_colourwriteenable(1, 1, 1, 0);
	
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
if (!ds_stack_empty(dwrt_queue))
{
	do
	{
		var routine = ds_stack_pop(dwrt_queue);
		script_execute(routine);
			
	} until (ds_stack_empty(dwrt_queue))
		
}
	
//haluc tim
//probably dedicate this to its own object? shrug
//if (keyboard_check(vk_backspace))
//{
//	dwrt_cctv_ekka_garble_1();
//}
	
draw_pop_state();
