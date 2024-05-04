world.set(identity_matrix);

view.set(mat_2d_view);
proj.set(mat_2d_proj);

view.push_stack(mat_2d_view);
proj.push_stack(mat_2d_proj);

current_view.render();

view.pop_stack();
proj.pop_stack();

gpu_push_state();
gpu_set_ztestenable(false);
gpu_set_zwriteenable(false);
gpu_set_alphatestenable(false);
gpu_set_texfilter(true);

begin
	var fac = player.panic.get_fac(timer.a);
	
	if (fac > EPSL)
	{
		var bc = floor(fac * fac * 255)
	
		gpu_set_blendmode(bm_subtract);
		draw_sprite_stretched_ext(
			spr_panic_placeholder, 0,
			0, 0,
			ref_w, ref_h,
			bc | (bc << 8) | (bc << 16),
			1
		);
	
		//gpu_set_blendmode_ext(bm_dest_colour, bm_one);
		var bc = floor(fac * fac * fac * 255)
		gpu_set_blendmode(bm_max);
		draw_sprite_stretched_ext(
			spr_lizz_panic_snow, timer.time * 15,
			0, 0,
			ref_w, ref_h,
			bc | (bc << 8) | (bc << 16),
			1
		);
	}
end

gpu_pop_state();

if (is_paused)
{
	draw_pause_screen();
}

draw_text(32, 32, "fps: "+tostr(fps_real)+"\nfps est: "+tostr(timer.est_fps));
