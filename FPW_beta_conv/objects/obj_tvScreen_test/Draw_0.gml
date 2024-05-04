/// @desc
if (!surface_exists(surf)) { surf = surface_create(RESW, RESH); }

if (surface_exists(surf))
{
	surface_set_target(surf);
	draw_clear(c_black);
	dwrt_cctv();
	surface_reset_target();
	
	draw_surface_ext(
		surf, x, y, image_xscale, image_yscale, image_angle, c_white, 1.
	);
	
}
