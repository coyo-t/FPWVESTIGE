/// @desc
var ms = meta_master.prev_frame;
if (sprite_exists(ms))
{
	draw_sprite_ext(
		meta_master.prev_frame, 0,
		0, 0, 1, 1, 0,
		c_white, image_alpha
	);
}

image_alpha -= dt() * 0.5;
