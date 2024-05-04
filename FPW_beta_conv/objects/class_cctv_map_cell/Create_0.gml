/// @desc
is_active = start_active;
is_mouse_over = false;
alpha_max = 1.
image_alpha = start_active ? alpha_max : 0.;
cctv_object = obj_cctv;
blip_volume = 0.4;
alpha_hover = 0.;

if (start_active)
	with (cctv_object)
		cctv_current_sector_id = other.id;


function draw_ico () begin
	image_alpha = lerp_dt_1d(image_alpha, is_active * alpha_max, 1000000);
	image_alpha = clamp(image_alpha, 0., alpha_max);

	alpha_hover = lerp_dt(alpha_hover, is_mouse_over && !is_active, 0.00001);
	alpha_hover = clamp(alpha_hover, 0., 1.);

	if (image_alpha > 0.)
	{
		draw_sprite_ext(
			sprite_index, image_index,
			0, 0,
			image_xscale, image_yscale,
			image_angle,
			image_blend, image_alpha
		);
	
	}


	if (sprite_exists(mouseover_sprite))
	{
		draw_sprite_ext(
			mouseover_sprite, image_index,
			0, 0,
			image_xscale, image_yscale,
			image_angle,
			c_white, alpha_hover
		);
	}

end
