middleman_surf = surface_create_unexist_depthless(middleman_surf, srf_w, srf_h);

if (surface_exists(middleman_surf))
{
	gpu_push_state();
	surface_set_target(middleman_surf);
		gpu_set_blendenable(0);
		draw_surface_stretched(appsurf, 0, 0, srf_w, srf_h);
	surface_reset_target();
	
	fpw.trans.world.push_stack(matrix_build(0, 0, depth, 0,0,0, mdl_size_w,mdl_size_h,1));
	fpw.trans.view.push_stack(matrix_build(0, 0, 0, 0,0,0, 1,1,1));
	
	gpu_set_texfilter(1);
	var tex = surface_get_texture(middleman_surf);
	//var tex = surface_get_texture(appsurf);
	
	vertex_submit(mdl, pr_trianglelist, tex);
	
	gpu_pop_state();
	fpw.trans.world.pop_stack();
	fpw.trans.view.pop_stack();
}
