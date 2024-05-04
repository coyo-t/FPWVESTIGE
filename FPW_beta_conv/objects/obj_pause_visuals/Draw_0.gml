/// @desc
if (sprite_exists(meta_master.prev_frame))
{
	draw_sprite_stretched_ext(
		meta_master.prev_frame, 0, 
		0, 0, 
		RESW, RESH,
		c_white, 0.25
	);
}

