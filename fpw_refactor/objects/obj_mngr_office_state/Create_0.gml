mats = fpw.trans;
gs = -1;

mdl_env = (function (_fp) {
	var f = buffer_load(_fp);
	var vb = vertex_create_buffer_from_buffer(f, global.vform_shadeless);
	buffer_delete(f);
	return vb
})(BASEPATH+"models/exportest_roudcube.vbm");

input = new InputMap();
input.add("interact",         mb_left,  InputKeyType.mouse);
input.add("togglepanic",      vk_space, InputKeyType.keyboard);
input.add("reset_player_pos", ord("1"), InputKeyType.keyboard);

input_enabled = true;

cctv_transition = instance_create_depth(0,0,0, obj_cctv_transition);
cctv_transition.parent = self;

function set_interaction (_state)
{
	input_enabled = _state;
	gs.set_grab_mouse(_state, true);
	
}

function on_switch_to (gs)
{
	gs.set_grab_mouse(true, 0);
}

function tick (gs)
{
	cctv_transition.tick(gs);
	
	var dr = gs.player.get_look_vector(1);
	
	entity_of_interest = find_interactable(gs.entities, dr);
	
	while (input.vore_down("interact"))
	{
		switch (instanceof(entity_of_interest))
		{
			case "EntityInteractTest":
			case "EntityInteractTest_cctv_switch":
				entity_of_interest.interact(gs);
				play_interact_sound(true);
				break;
			default:
				play_interact_sound(false);
				break;
		}
	}
}

function step (gs)
{
	if (input_enabled)
	{
		gs.turn_player(gs.player, gs);
		input.update();
	}
	else
	{
		input.clear_all();
	}
}

function end_step (gs)
{
	input.end_update();
}

cube_surf = -1;
function draw_cubemap_test (spr, _sz)
{
	mats.world.push_stack();
	var tex;
	var rot_mat = matrix_build(0,0,0, 0,-90,0, 1,1,1);
	var scale_mat = matrix_build_scale(-_sz,-_sz,-_sz);
	
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
	vertex_submit(mdl_env, pr_trianglelist, tex);
	
	// right
	tex = sprite_get_texture(spr, 1);
	mats.world.mul(rot_mat);
	vertex_submit(mdl_env, pr_trianglelist, tex);
	
	// back
	tex = sprite_get_texture(spr, 2);
	mats.world.mul(rot_mat);
	vertex_submit(mdl_env, pr_trianglelist, tex);
	
	// left
	tex = sprite_get_texture(spr, 3);
	mats.world.mul(rot_mat);
	vertex_submit(mdl_env, pr_trianglelist, tex);
	
	// up
	tex = sprite_get_texture(spr, 4);
	mats.world.set(matrix_multiply(scale_mat, matrix_build(0,0,0, 90,0,0, 1,1,1)));
	vertex_submit(mdl_env, pr_trianglelist, tex);
	
	// down
	tex = sprite_get_texture(spr, 5);
	mats.world.set(matrix_multiply(scale_mat, matrix_build(0,0,0, -90,0,0, 1,1,1)));
	vertex_submit(mdl_env, pr_trianglelist, tex);
	
	mats.world.pop_stack();
}

function render_office (gs)
{
	var plr = gs.player;
	var t = gs.timer;
	var ents = gs.entities;
	var def_view = camera_get_view_mat(camera_get_default());
	var def_proj = camera_get_proj_mat(camera_get_default());

	mats.view.set(def_view);
	mats.proj.set(def_proj);

	var zf = gpu_get_zfunc();

	gpu_push_state();
	gpu_set_ztestenable(true);
	gpu_set_zwriteenable(true);
	gpu_set_cullmode(cull_counterclockwise);
	gpu_set_texfilter(1);

	gs.mat_3d_view = gs.move_camera_to_player(plr, t.a);

	mats.view.push_stack(gs.mat_3d_view);
	mats.proj.push_stack(gs.mat_3d_proj);

	var vb = vertex_create_buffer();
	draw_cubemap_test(env_test_1, 20);
	
	for (var i = 0, len = array_length(ents); i < len; ++i)
	{
		ents[i].draw(gs);
	}

	gpu_set_zfunc(cmpfunc_always);

	vertex_delete_buffer(vb);

	gpu_set_zfunc(zf);

	mats.view.pop_stack();
	mats.proj.pop_stack();

	gpu_pop_state();

}

function render_ui (gs)
{
	if (cctv_transition.visible)
	{
		cctv_transition.draw(gs);
		return;
	}
	
	var port_w = 1280;
	var port_h = 720;
	var plr = gs.player;
	var dr = plr.get_look_vector(10);
	
	gpu_push_state();
	gpu_set_texfilter(false);
	gpu_set_blendmode(bm_normal);
	gpu_set_alphatestenable(true);

	gpu_set_alphatestenable(false);

	///TODO: make the crosshair sort-of stick in space
	var cx = port_w >> 1;
	var cy = port_h >> 1;

	mats.world.push_stack(matrix_build(cx, cy, depth, 0,0,0, 1,-1,1));

	var cp = world_to_screen(dr[0], dr[1], dr[2], gs.mat_3d_view, gs.mat_3d_proj);

	if (entity_of_interest != -1)
	{
		crosshair_ind_x = 2;
		crosshair_ind_y = 2;
	}
	else
	{
		crosshair_ind_x = 1;
		crosshair_ind_y = 0;
	}

	draw_crosshair(cp[0] * cx, -cp[1] * cy, crosshair_ind_x, crosshair_ind_y);

	mats.world.pop_stack();

	gpu_pop_state();


	if (entity_of_interest != -1)
	{
		var scr_spc_p = world_to_screen(
			entity_of_interest.x,
			entity_of_interest.y,
			entity_of_interest.z,
			gs.mat_3d_view,
			gs.mat_3d_proj
		);
	
		if (scr_spc_p[2] > 0)
		{
			var gx = (scr_spc_p[0] * .5 + .5) * port_w;
			var gy = (scr_spc_p[1] * .5 + .5) * port_h;
		
			draw_sprite_ext(
				__spr_testinteract_overlay, 0,
				gx + (cx - gx) * .25,
				gy + (cy - gy) * .25,
				1, 1,
				0,
				c_white,
				0.5
			);
		}
	}
}

entity_of_interest = -1;

function find_interactable (ents, plr_dir)
{
	var targ = -1;
	var targ_dist = infinity;
	//var plr_dir = player.get_look_vector(1);
	
	for (var ie = 0, l = array_length(ents); ie < l; ie++)
	{
		var ee = ents[ie]
		var hit = ee.aabb.vs_ray([0,0,0], plr_dir);
		
		if (hit > 0)
		{
			if (hit < targ_dist)
			{
				targ = ee;
			}
		}
	}
	
	return targ;
}

sfx_chan_ui = -1;
function play_interact_sound (_hit)
{
	if (audio_is_playing(sfx_chan_ui))
	{
		audio_stop_sound(sfx_chan_ui);
	}
	
	sfx_chan_ui = audio_play_sound(
		_hit ? sfx_interact_success : sfx_interact_null, 
		0, 
		false
	);
	
	audio_sound_gain(sfx_chan_ui, 0.25, 0);
}

// ----

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
