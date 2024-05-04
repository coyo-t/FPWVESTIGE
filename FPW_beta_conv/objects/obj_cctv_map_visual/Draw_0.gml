/// @desc
var mx = meta_master.get_inp("mouse_x");
var my = meta_master.get_inp("mouse_y");

/// static
//todo ; -;


/// map image and cells

var inbound = point_in_bbox(mx, my);

image_alpha = lerp_dt_1d(image_alpha, inbound, 1000000);
image_alpha = clamp(image_alpha, alpha_unfocused, alpha_focused);

surface = surface_create_unexist_depthless(surface, sprite_width, sprite_height);

if (surface_exists(surface))
{
	surface_set_target(surface);
	gpu_push_state();
	gpu_set_colourwriteenable(true, true, true, true);
	draw_clear_alpha(c_black, 0.);
	draw_sprite_ext(
		sprite_index, image_index,
		0, 0,
		image_xscale, image_yscale,
		image_angle,
		c_white, 1.
	);
	with (class_cctv_map_cell)
	{
		draw_ico();
		//event_perform(ev_draw, ev_draw);
		
	}
	
	draw_sprite_ext(
		spr_cctv_map_blip, 
		time() * sprite_get_speed(spr_cctv_map_blip),
		0, 0,
		1, 1,
		0, 
		image_blend, 1.
	);
	
	gpu_pop_state();
	surface_reset_target();
	
	draw_surface_ext(
		surface,
		x, y,
		1, 1,
		0, c_white,
		clamp(image_alpha, 0., 1.)
	);
	
}


// character icons
if (DEBUG_SHOW_CHAR_ICONS)
{
	with (class_char_ai)
	{
		draw_char_ico();
	}

}


// border around the screen
var borderspr = spr_cctv_border;

draw_sprite_ext(
	borderspr, 0, 
	0, 0,
	1, 1,
	0,
	c_white, image_alpha
);

var sect_id = obj_cctv.cctv_current_sector_id;
var sect = sect_id.name_sprite;

// draw navball
if (object_get_parent(sect_id.object_index) == class_cctv_map_cell_cube)
{
	navball_surface = surface_create_unexist(navball_surface, navball_srf_w, navball_srf_h);
	
	surface_set_target(navball_surface);
	gpu_push_state();
	gpu_set_colourwriteenable(1,1,1,1);
	draw_clear_alpha(c_black, 0.);
	
	var ox = sprite_get_xoffset(navball_frame);
	var oy = sprite_get_yoffset(navball_frame);
	
	draw_sprite(navball_frame, 0, ox, oy);
	
	gpu_set_cullmode(cull_clockwise);
	matrix_world_set(matrix_build(
		navball_size + ox, navball_size + oy, -depth,
		
		sect_id.camera_pitch + sect_id.navball_pitch,
		(sect_id.camera_yaw - 90) + sect_id.navball_yaw,
		sect_id.camera_roll + sect_id.navball_roll,
		
		navball_size, navball_size, navball_size
	));
	
	//shader_set(sha_depthtest);
	vertex_submit(navball_mesh, pr_trianglelist, sprite_get_texture(spr_naballplacehold, 0));
	
	matrix_world_reset();
	gpu_pop_state();
	surface_reset_target();
	
	draw_surface_ext(navball_surface, navball_pos[0] + ox, navball_pos[1] + oy, 1, 1, 0, c_white, image_alpha);
	
}

/// sector name in nemmii
if (sprite_exists(sect))
{
	if (sector_name_shadow_offset[0] != 0 || sector_name_shadow_offset[1] != 0)
	{
		draw_sprite_ext(
			sect, 0,
			sprite_get_bbox_left(borderspr) + sector_name_shadow_offset[0],
			sprite_get_bbox_top(borderspr)  + sector_name_shadow_offset[1],
			1, 1,
			0,
			c_black, 1.
		);
	}

	draw_sprite(sect, 0, sprite_get_bbox_left(borderspr), sprite_get_bbox_top(borderspr));
}
