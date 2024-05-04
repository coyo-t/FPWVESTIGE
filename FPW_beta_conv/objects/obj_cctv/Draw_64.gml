/// @desc
if (is_enabled)
{
	if (!mouse_still_over)
	{
		if (is_cctv_active)
		{
			draw_sprite_ext(
				cctv_button_on_rect[4], 0,
				cctv_button_on_rect[0], cctv_button_on_rect[1],
				1, 1, 0,
				c_white, obj_cctv_map_visual.image_alpha
			);
			
		} else {
			draw_sprite_ext(
				sprite_index, image_index,
				x, y + (is_cctv_active ? sprite_height : 0),
				image_xscale, image_yscale * (is_cctv_active ? -1 : 1),
				0, 
				colour_inactive, //is_cctv_active ? colour_active : colour_inactive,
				image_alpha
			);
		}
	}
}
