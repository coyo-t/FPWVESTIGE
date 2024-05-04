screen_surf = surface_create_unexist_depthless(screen_surf, surf_w, surf_h);

var sexist = surface_exists(screen_surf);

// i realised that this says sexist much after i wrote it
// im keeping it, bithc.
if (sexist)
{
	gpu_push_state();
	surface_set_target(screen_surf); {
		draw_sprite_stretched_ext(background, 0, 0, 0, surf_w, surf_h, c_dkgrey, 1.);
		draw_text_transformed(0, 0, "YOTE", 2, 2, 0);
	} surface_reset_target();
	
	
	fpw.trans.world.push_stack(mdl_matrix);
	gpu_set_texfilter(true);
	vertex_submit(mdl, pr_trianglelist, surface_get_texture(screen_surf));
	gpu_pop_state();
	fpw.trans.world.pop_stack();
}
