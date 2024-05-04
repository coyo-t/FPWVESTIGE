function draw_cubemap_oh_jesus (vb, spr)
{
	var s = -10;
	var w = 10;
	var c = $ffFFffFF
	var tex;

	// front
	vertex_begin(vb, _G.vform_shadeless);
		add_point_3d_uv(vb, s, w, w, 0., 0., c);
		add_point_3d_uv(vb, w, w, w, 1., 0., c);
		add_point_3d_uv(vb, s, s, w, 0., 1., c);

		add_point_3d_uv(vb, s, s, w, 0., 1., c);
		add_point_3d_uv(vb, w, w, w, 1., 0., c);
		add_point_3d_uv(vb, w, s, w, 1., 1., c);
	vertex_end(vb);
	vertex_submit(vb, pr_trianglelist, tex);
	
	// back
	tex = sprite_get_texture(spr, 2);
	vertex_begin(vb, _G.vform_shadeless);
		add_point_3d_uv(vb, w, w, s, 0., 0., c);
		add_point_3d_uv(vb, s, w, s, 1., 0., c);
		add_point_3d_uv(vb, s, s, s, 1., 1., c);
	
		add_point_3d_uv(vb, w, w, s, 0., 0., c);
		add_point_3d_uv(vb, s, s, s, 1., 1., c);
		add_point_3d_uv(vb, w, s, s, 0., 1., c);
	vertex_end(vb);
	vertex_submit(vb, pr_trianglelist, tex);

	// right
	tex = sprite_get_texture(spr, 1);
	vertex_begin(vb, _G.vform_shadeless);
		add_point_3d_uv(vb, w, w, w, 0., 0., c);
		add_point_3d_uv(vb, w, w, s, 1., 0., c);
		add_point_3d_uv(vb, w, s, w, 0., 1., c);
	
		add_point_3d_uv(vb, w, s, w, 0., 1., c);
		add_point_3d_uv(vb, w, w, s, 1., 0., c);
		add_point_3d_uv(vb, w, s, s, 1., 1., c);
	vertex_end(vb);
	vertex_submit(vb, pr_trianglelist, tex);

	// left
	tex = sprite_get_texture(spr, 3);
	vertex_begin(vb, _G.vform_shadeless);
		add_point_3d_uv(vb, s, w, s, 0., 0., c);
		add_point_3d_uv(vb, s, w, w, 1., 0., c);
		add_point_3d_uv(vb, s, s, s, 0., 1., c);

		add_point_3d_uv(vb, s, s, s, 0., 1., c);
		add_point_3d_uv(vb, s, w, w, 1., 0., c);
		add_point_3d_uv(vb, s, s, w, 1., 1., c);
	vertex_end(vb);
	vertex_submit(vb, pr_trianglelist, tex);

	// up
	tex = sprite_get_texture(spr, 4);
	vertex_begin(vb, _G.vform_shadeless);
		add_point_3d_uv(vb, s, w, w, 0., 1., c);
		add_point_3d_uv(vb, s, w, s, 0., 0., c);
		add_point_3d_uv(vb, w, w, s, 1., 0., c);
	
		add_point_3d_uv(vb, s, w, w, 0., 1., c);
		add_point_3d_uv(vb, w, w, s, 1., 0., c);
		add_point_3d_uv(vb, w, w, w, 1., 1., c);
	vertex_end(vb);
	vertex_submit(vb, pr_trianglelist, tex);

	// down
	tex = sprite_get_texture(spr, 5);
	vertex_begin(vb, _G.vform_shadeless);
		add_point_3d_uv(vb, s, s, w, 0., 0., c);
		add_point_3d_uv(vb, w, s, w, 1., 0., c);
		add_point_3d_uv(vb, s, s, s, 0., 1., c);
	
		add_point_3d_uv(vb, s, s, s, 0., 1., c);
		add_point_3d_uv(vb, w, s, w, 1., 0., c);
		add_point_3d_uv(vb, w, s, s, 1., 1., c);
	vertex_end(vb);
	vertex_submit(vb, pr_trianglelist, tex);
	
}
