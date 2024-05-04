test_roundcube = (function (_fp) {
	var f = buffer_load(_fp);
	var vb = vertex_create_buffer_from_buffer(f, global.vform_shadeless);
	buffer_delete(f);
	return vb
})(BASEPATH+"models/exportest_roudcube.vbm");

t = new Timer(20);

fov = 90;
view_enabled = true;

view_set_visible(0, true);
view_set_wport(0, appsurf_w);
view_set_hport(0, appsurf_h);
view_set_xport(0, 0);
view_set_yport(0, 0);

gamestate = {
	timer: t,
	player: -1,
}

states = ds_map_create();

player = new Fpw_Player(gamestate);

gamestate[$"player"] = player;

//function find_interactable (_ents)
//{
//	var targ = -1;
//	var targ_dist = infinity;
//	var plr_dir = player.get_look_vector(1);
	
//	for (var ie = 0, l = array_length(_ents); ie < l; ie++)
//	{
//		var ee = _ents[ie]
//		var hit = ee.aabb.vs_ray([0,0,0], plr_dir);
		
//		if (hit > 0)
//		{
//			if (hit < targ_dist)
//			{
//				targ = ee;
//			}
//		}
//	}
	
//	return targ;
//}

//function get_mouse_prop (_retard)
//{
//	var mofx = window_get_x();
//	var mofy = window_get_y();
	
//	var mw = (window_get_width() >> 1);
//	var mh = (window_get_height() >> 1);
	
//	var mx = ((display_mouse_get_x() - mofx) - mw) / appsurf_r;
//	var my = ((display_mouse_get_y() - mofy) - mh) / appsurf_r;
	
//	return {
//		mw:mw,
//		mh:mh,
//		mx:mx * _retard,
//		my:my * _retard,
//		mofx:mofx,
//		mofy:mofy,
//		rmx: display_mouse_get_x(),
//		rmy: display_mouse_get_y()
//	};
//}

function rebuild_proj_mat (_fov)
{
	mat_3d_proj = matrix_build_projection_perspective_fov(
		fov_h2v(_fov, appsurf_w, appsurf_h),
		appsurf_w / appsurf_h,
		0.01,
		20000
	);
}

cube_surf = -1;
function draw_cubemap_test (vb, spr, _sz)
{
	mats.world.push_stack();
	var tex;
	var rot_mat = matrix_build(0,0,0, 0,-90,0, 1,1,1);
	var scale_mat = matrix_build_scale(_sz,_sz,_sz);
	
	// front
	mats.view.push_stack();
	mats.proj.push_stack();
	if (!surface_exists(cube_surf))
	{
		cube_surf = surface_create(2048, 2048);
	}
	surface_set_target(cube_surf);
		draw_clear(c_black);
		draw_sprite(spr, 0, 0,0);
		draw_sprite(__spr_yote, 0, 512, 512 + (sin(TIME * 5) * 100));
	surface_reset_target();
	
	mats.view.pop_stack();
	mats.proj.pop_stack();
	//tex = sprite_get_texture(spr, 0);
	tex = surface_get_texture(cube_surf);
	mats.world.set(scale_mat);
	vertex_submit(test_roundcube, pr_trianglelist, tex);
	
	// right
	tex = sprite_get_texture(spr, 1);
	mats.world.mul(rot_mat);
	vertex_submit(test_roundcube, pr_trianglelist, tex);
	
	// back
	tex = sprite_get_texture(spr, 2);
	mats.world.mul(rot_mat);
	vertex_submit(test_roundcube, pr_trianglelist, tex);
	
	// left
	tex = sprite_get_texture(spr, 3);
	mats.world.mul(rot_mat);
	vertex_submit(test_roundcube, pr_trianglelist, tex);
	
	// up
	tex = sprite_get_texture(spr, 4);
	mats.world.set(matrix_multiply(scale_mat, matrix_build(0,0,0, 90,0,0, 1,1,1)));
	vertex_submit(test_roundcube, pr_trianglelist, tex);
	
	// down
	tex = sprite_get_texture(spr, 5);
	mats.world.set(matrix_multiply(scale_mat, matrix_build(0,0,0, -90,0,0, 1,1,1)));
	vertex_submit(test_roundcube, pr_trianglelist, tex);
	
	mats.world.pop_stack();
}


/////TODO: make me take roll into account too?
//function move_listener (_x, _y, _z, _ap, _ay)
//{
//	var am = matrix_build(0,0,0, _ap, _ay, 0, 1,1,1);
//	audio_listener_position(-_x, -_y, _z);
	
//	var axis_y = matrix_transform_vertex(am, 0, -1, 0);
//	var axis_z = matrix_transform_vertex(am, 0, 0, 1);

//	audio_listener_orientation(axis_z[0], axis_z[1], axis_z[2], axis_y[0], axis_y[1], axis_y[2]);
//}

//function move_camera_to_player (plr, a, gs)
//{
//	audio_listener_velocity(0, 0, 0);
//	mats.push_stack();
//	var pfac = plr.panic.get_fac(a);
	
//	if (plr.panic.fac > 0)
//	{
//		var _mat = plr.panic.get_distortion_matrix(a);
//		mats.push(_mat);
//		audio_listener_velocity(_mat[4] * 500 * pfac, _mat[1] * 500 * pfac, (_mat[10] - 1) * 500 * pfac);
//	}
//	pfac *= pfac;
	
//	var bobx = (sin(TIME * pi * .9)  * (.05 + pfac * .5)) + (1.25 * pfac);
//	var boby = (cos(TIME * pi * .45) * (.1 + pfac * 1.8));
	
//	mats.push(matrix_build(0, 0, 0, bobx,boby,-boby * 2., 1,1,1))
	
//	var plrx = plr.tlerp(plr.x, plr.ox, a);
//	var plry = plr.tlerp(plr.y, plr.oy, a);
//	var plrz = plr.tlerp(plr.z, plr.oz, a);
	
//	//mats.push(matrix_build(0, 0, 0, 0,0, plr.tlerp(plr.ar, plr.oar, a), 1,1,1));
//	mats.push(matrix_build(0, 0, 0, 0,0, plr.tlerp(plr.ar, plr.oar, a), 1,1,1));
//	mats.push(matrix_build(0, 0, 0, plr.ap,plr.ay,0, 1,1,1));
//	mats.push(matrix_build_position(plrx, plry, plrz));
	
//	var m = mats.top();
//	mats.pop_stack();

//	move_listener(plrx, plry, plrz, plr.ap, plr.ay)
	
//	return m;
//}

//function turn_player (plr, gs)
//{
//	static dmx = 0;
//	static dmy = 0;
	
//	var ost = grab_mouse;
//	grab_mouse = mouse_check_button(mb_right);
//	var mp = get_mouse_prop(.25);
	
//	dmx = (dmx + mp.mx) * .5;
//	dmy = (dmy + mp.my) * .5;
	
//	var tm = plr.panic.get_fac(gs.timer.a);
	
//	if (grab_mouse != ost)
//	{
//		if (grab_mouse)
//		{
//			dmx = 0;
//			dmy = 0;
//			set_cursor(cr_none);
//		}
//		else
//		{
//			set_cursor(cr_default);
//		}
//	}
	
//	if (grab_mouse)
//	{
//		display_mouse_set(
//			mp.mw + mp.mofx,
//			mp.mh + mp.mofy
//		);
		
//		player.turn(dmx, dmy);
//		player.ar = clamp(player.ar - dmx * (.15 + (.2 * tm)), -10, 10);
//		return;
//	}
//}

//function set_cursor (_cr)
//{
//	window_set_cursor(_cr);
//}

crosshair_ind_x = 0;
crosshair_ind_y = 0;
function draw_crosshair (_x, _y, _ix, _iy)
{
	var cr_spr = spr_hl_crosshair_test;
	var cr_w = sprite_get_bbox_right(cr_spr);
	var cr_h = sprite_get_bbox_bottom(cr_spr);
	var cr_ix = _ix * cr_w;
	var cr_iy = _iy * cr_h;
	var cr_ofs_x = sprite_get_xoffset(cr_spr);
	var cr_ofs_y = sprite_get_yoffset(cr_spr);
	
	gpu_push_state();
	gpu_set_texfilter(false);
	gpu_set_blendmode_ext(
		bm_inv_dest_colour,
		bm_inv_src_colour
	);

	draw_sprite_part_ext(
		spr_hl_crosshair_test, 0,
		cr_ix, cr_iy, cr_w, cr_h,
		floor(_x - cr_ofs_x), floor(_y - cr_ofs_y),
		1., 1.,
		c_white, 1.
	);
	
	gpu_pop_state();
}

function kill_entities (hitlist)
{
	for (var k = 0, l = array_length(hitlist); k < l; k += 2)
	{
		var ei = hitlist[k];
		var ee = hitlist[k + 1];
				
		array_delete(entities, ei, 1);
		ee.kill();
		delete ee;
	}
	
}


sfx_chan_ui = -1;

function rebuild_proj_mat (_fov)
{
	mat_3d_proj = matrix_build_projection_perspective_fov(
		fov_h2v(_fov, appsurf_w, appsurf_h),
		appsurf_w / appsurf_h,
		0.01,
		20000
	);
}

// office shit

//function render_office ()
//{
//	var plr = gs.player;
//	var t = gs.timer;
//	var def_view = camera_get_view_mat(camera_get_default());
//	var def_proj = camera_get_proj_mat(camera_get_default());

//	mats.view.set(def_view);
//	mats.proj.set(def_proj);

//	var zf = gpu_get_zfunc();

//	var port_w = 1280;
//	var port_h = 720;


//	gpu_push_state();
//	gpu_set_ztestenable(true);
//	gpu_set_zwriteenable(true);
//	gpu_set_cullmode(cull_counterclockwise);
//	gpu_set_texfilter(1);

//	mat_3d_view = move_camera_to_player(plr, t.a, gs);

//	mats.view.push_stack(mat_3d_view);
//	mats.proj.push_stack(mat_3d_proj);

//	var vb = vertex_create_buffer();
//	draw_cubemap_test(vb, env_test_1, -20);
	
//	for (var i = 0, len = array_length(entities); i < len; ++i)
//	{
//		entities[i].draw(gamestate);
//	}

//	gpu_set_zfunc(cmpfunc_always);

//	var dr = plr.get_look_vector(10);

//	vertex_delete_buffer(vb);

//	gpu_set_zfunc(zf);

//	mats.view.pop_stack();
//	mats.proj.pop_stack();

//	gpu_pop_state();

//	gpu_push_state();
//	gpu_set_ztestenable(false);
//	gpu_set_zwriteenable(false);
//	gpu_set_alphatestenable(false);
//	gpu_set_blendmode(bm_subtract);
//	gpu_set_texfilter(true);
//	draw_sprite_stretched_ext(spr_vinyet, 0, 0, 0, port_w, port_h, $8f8f8f, 1.);

//	{
//		var fac = plr.panic.get_fac(t.a);
//		var bc = floor(fac * fac * 255)
//		draw_sprite_stretched_ext(
//			spr_panic_placeholder, 0,
//			0, 0,
//			port_w, port_h,
//			bc | (bc << 8) | (bc << 16),
//			1.
//		);
//	}

//	gpu_set_texfilter(false);
//	gpu_set_blendmode(bm_normal);
//	gpu_set_alphatestenable(true);

//	gpu_set_alphatestenable(false);

//	///TODO: make the crosshair sort-of stick in space
//	var cx = port_w >> 1;
//	var cy = port_h >> 1;

//	mats.world.push_stack(matrix_build(cx, cy, depth, 0,0,0, 1,-1,1));

//	var cp = world_to_screen(dr[0], dr[1], dr[2], mat_3d_view, mat_3d_proj);

//	if (entity_of_interest != -1)
//	{
//		crosshair_ind_x = 2;
//		crosshair_ind_y = 2;
//	}
//	else
//	{
//		crosshair_ind_x = 1;
//		crosshair_ind_y = 0;
//	}

//	draw_crosshair(cp[0] * cx, -cp[1] * cy, crosshair_ind_x, crosshair_ind_y);

//	mats.world.pop_stack();

//	gpu_pop_state();


//	if (entity_of_interest != -1)
//	{
//		var scr_spc_p = world_to_screen(
//			entity_of_interest.x,
//			entity_of_interest.y,
//			entity_of_interest.z,
//			mat_3d_view,
//			mat_3d_proj
//		);
	
//		if (scr_spc_p[2] > 0)
//		{
//			var gx = (scr_spc_p[0] * .5 + .5) * port_w;
//			var gy = (scr_spc_p[1] * .5 + .5) * port_h;
		
//			draw_sprite_ext(
//				__spr_testinteract_overlay, 0,
//				gx + (cx - gx) * .25,
//				gy + (cy - gy) * .25,
//				1, 1,
//				0,
//				c_white,
//				0.5
//			);
//		}
//	}
//}


// ----

//entity_of_interest = -1;

//function find_interactable ()
//{
//	var targ = -1;
//	var targ_dist = infinity;
//	var plr_dir = player.get_look_vector(1);
	
//	for (var ie = 0, l = array_length(entities); ie < l; ie++)
//	{
//		var ee = entities[ie]
//		var hit = ee.aabb.vs_ray([0,0,0], plr_dir);
		
//		if (hit > 0)
//		{
//			if (hit < targ_dist)
//			{
//				targ = ee;
//			}
//		}
//	}
	
//	return targ;
//}


//function play_interact_sound (_hit)
//{
//	if (audio_is_playing(gs.sfx_chan_ui))
//	{
//		audio_stop_sound(gs.sfx_chan_ui);
//	}
	
//	gs.sfx_chan_ui = audio_play_sound(
//		_hit ? sfx_interact_success : sfx_interact_null, 
//		0, 
//		false
//	);
	
//	audio_sound_gain(gs.sfx_chan_ui, 0.25, 0);
//}

//// ----

//crosshair_ind_x = 0;
//crosshair_ind_y = 0;

//function draw_crosshair (_x, _y, _ix, _iy)
//{
//	var cr_spr = spr_hl_crosshair_test;
//	var cr_w = sprite_get_bbox_right(cr_spr);
//	var cr_h = sprite_get_bbox_bottom(cr_spr);
//	var cr_ix = _ix * cr_w;
//	var cr_iy = _iy * cr_h;
//	var cr_ofs_x = sprite_get_xoffset(cr_spr);
//	var cr_ofs_y = sprite_get_yoffset(cr_spr);
	
//	gpu_push_state();
//	gpu_set_texfilter(false);
//	gpu_set_blendmode_ext(
//		bm_inv_dest_colour,
//		bm_inv_src_colour
//	);

//	draw_sprite_part_ext(
//		spr_hl_crosshair_test, 0,
//		cr_ix, cr_iy, cr_w, cr_h,
//		floor(_x - cr_ofs_x), floor(_y - cr_ofs_y),
//		1., 1.,
//		c_white, 1.
//	);
	
//	gpu_pop_state();
//}

// ----

array_push(entities,
	(new EntityInteractTest(gamestate))
		.set_loc_no_history(-10, 0, 0)
		.set_aabb(.5, 10, 5)
);

array_push(entities,
	(new EntityInteractTest(gamestate))
		.set_loc_no_history(10, 0, 0)
		.set_aabb(.5, 10, 5)
);

array_push(entities,
	(new EntityInteractTest(gamestate))
		.set_loc_no_history(9, -.5, -3)
		.set_aabb(1.5, 2, 1.5)
);

array_push(entities,
	(new EntityInteractTest(gamestate))
		.set_loc_no_history(0, 6, -15)
		.set_aabb(8, 6, 5)
);
