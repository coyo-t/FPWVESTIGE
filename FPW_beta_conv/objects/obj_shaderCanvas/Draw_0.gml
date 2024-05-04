if (floor(abs(sprite_width)) != 0 && floor(abs(sprite_height)) != 0)
{
	#region surface resizing
	var cam = view_camera[view_current];
	var cam_coords = [
		camera_get_view_x(cam), 
		camera_get_view_y(cam),
		camera_get_view_width(cam), 
		camera_get_view_height(cam)
	];

	view_collide = rectangle_in_rectangle(
		bbox_left,  bbox_top, 
		bbox_right, bbox_bottom,

		cam_coords[p_arr.x], cam_coords[p_arr.y],
		cam_coords[p_arr.x] + cam_coords[p_arr.w], cam_coords[p_arr.y] + cam_coords[p_arr.h],
	);

	if (!surface_exists(surface) || sprite_width != width_last || sprite_height != height_last) &&
		(sprite_width != 0 && sprite_height != 0)
	{
		surface = surface_create(abs(sprite_width), abs(sprite_height));
	}

	copy_pos = [
		bbox_left - cam_coords[p_arr.x],
		bbox_top - cam_coords[p_arr.y],
		abs(sprite_width),
		abs(sprite_height)
	];

	/*
	if (view_collide == collide_return.overlap)
	{
		var ox = copy_pos[p_arr.x];
		var oy = copy_pos[p_arr.y];
	
		copy_pos[p_arr.x] = max(ox, cam_coords[0]);
		copy_pos[p_arr.y] = max(oy, cam_coords[1]);
		copy_pos[p_arr.w] = min(ox + sprite_width, cam_coords[0] + cam_coords[2]) - copy_pos[p_arr.x];
		copy_pos[p_arr.h] = min(oy + sprite_height, cam_coords[1] + cam_coords[3]) - copy_pos[p_arr.y];
	
		surface_resize(surface, copy_pos[p_arr.w], copy_pos[p_arr.h]);
	
	}
	*/
	#endregion
	
	if (view_collide != collide_return.none && surface_exists(surface))
	{
		//is there a view to copy from
		var copy_source = view_enabled && surface_exists(view_surface_id[view_current])
			? view_surface_id[view_current]
			: application_surface;
		
		//or is there a surface being drawn to already (ie, layer bullshit)
		copy_source = surface_get_target() != -1
			? surface_get_target()
			: copy_source;
		
		surface_clear(surface, $0);
		gpu_push_state();
		gpu_set_colourwriteenable(true, true, true, false);
		
		surface_copy_part(
			surface, 0, 0,
			copy_source,
			copy_pos[p_arr.x], copy_pos[p_arr.y],
			copy_pos[p_arr.w], copy_pos[p_arr.h]
		);
		
		gpu_pop_state();
		
		//draw it
		if (!override_shader_set) then shader_set(shader_name);
		
		if (!override_surface_draw)
		{
			draw_surface_ext(
				surface, bbox_left, bbox_top,
				1, 1,
				0, 
				image_blend,
				image_alpha
			);
			
		} else { override_func(); }
		
		if (!override_shader_set) then shader_reset();
		
	}
	
}

/*
draw_push_state();
draw_set_colour(c_red);

draw_text(32, 32, 
	string(surface_get_width(surface)) + "\n" + string(surface_get_height(surface)) + "\n" + string(view_collide)
);

draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
draw_line(bbox_left, bbox_top, bbox_right, bbox_bottom)

draw_pop_state();
*/
