function draw_border (_x, _y)
{
	draw_sprite(spr_cctv_border, 0, _x, _y);
	draw_sprite(spr_cctv_border, 1, _x, _y);
	draw_sprite(spr_cctv_border, 2, _x, _y);
	draw_sprite(spr_cctv_border, 3, _x, _y);
}

map_surf = -1;

cameras = -1;

begin // loading of cam buttons
	var pth = @"D:\_projects\parallel2shit\nbt\";
	var nbtreader = new Nbt_buffer_reader();
	var nbtdata = nbtreader.load_file(pth+"cameras.nbt");
	cameras = nbtdata.to_struct()[1];
	nbtdata.destroy();
	delete nbtreader;
	delete nbtdata;
end

function tick (_mom)
{
	
}

function draw (_mom)
{
	draw_border(0, 0);
	
	if (!surface_exists(map_surf))
	{
		var sd = surface_get_depth_disable();
		surface_depth_disable(true);
		map_surf = surface_create(sprite_width, sprite_height);
		surface_depth_disable(sd);
	}
	
	_mom.push_surface_target(map_surf);
		draw_clear_alpha(c_black, 0.);
		draw_sprite(sprite_index, 0, 0, 0);
		
		gpu_set_blendmode_ext_sepalpha(
			bm_src_alpha,
			bm_inv_src_alpha,
			bm_dest_alpha,
			bm_dest_alpha
		);
		draw_sprite_ext(
			spr_cctv_map_buttons_hover, 0,
			0, 0,
			1, 1, 0,
			c_white,
			1. - (sin(_mom.timer.time) * .5 + .5)
		);
		draw_sprite_ext(
			spr_cctv_map_buttons_active, 0,
			0, 0,
			1, 1, 0,
			c_white,
			sin(_mom.timer.time) * .5 + .5
		);
	_mom.pop_surface_target();
	
	draw_surface(map_surf, x, y);
	
}

