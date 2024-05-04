surf = surface_create_unexist_depthless(surf, sprite_width, sprite_height);

if (surface_exists(surf))
{
	surface_set_target(surf); begin
		draw_sprite(sprite_index, 0, 0, 0);
		draw_sprite_ext(spr_cctv_map_blip, -1, 0, 0, 1, 1, 0, $00AFDE, 1.);
		
	end surface_reset_target();
	
	draw_surface_ext(surf, x, y, 1, 1, 0, c_white, 0.5);
	
}
