mom = -1;

enum Envmap_dir {
	front = 0,
	right = 1,
	back = 2,
	left = 3,
	up = 4,
	down = 5
};

has_been_destroyed = false;

hud_display_enabled = true;

mdl_env = (function (_fp)
{
	var f = buffer_load(_fp);
	var v = vertex_create_buffer_from_buffer(f, _G.vformat_xyz_uv_col);
	buffer_delete(f);
	vertex_freeze(v);
	return v;
})("./mdls/env_part.vbm");

function draw_env_part (_dir, _tex, _sz)
{
	var mat = matrix_build_scale(-_sz, -_sz, -_sz);
	var dirmat = identity_matrix;
	
	// we dont bother with case 0 since that faces forwards anyway
	switch (_dir)
	{
		case Envmap_dir.right:
			dirmat = matrix_build(0,0,0, 0,-90,0, 1,1,1);
			break;
		case Envmap_dir.back:
			dirmat = matrix_build(0,0,0, 0,-180,0, 1,1,1);
			break;
		case Envmap_dir.left:
			dirmat = matrix_build(0,0,0, 0,-270,0, 1,1,1);
			break;
		case Envmap_dir.up:
			dirmat = matrix_build(0,0,0, 90,0,0, 1,1,1);
			break;
		case Envmap_dir.down:
			dirmat = matrix_build(0,0,0, -90,0,0, 1,1,1);
			break;
	}
	
	mom.world.push_stack(matrix_multiply(mat, dirmat));
	vertex_submit(mdl_env, pr_trianglelist, _tex);
	mom.world.pop_stack();
}

entity_of_interest = -1;

function find_interactable (_ents, _dir)
{
	var targ = -1;
	var targ_dist = infinity;
	var pos = [0,0,0];
	
	for (var ie = 0, l = array_length(_ents); ie < l; ie++)
	{
		var ee = _ents[ie]
		
		if (is_undefined(ee.aabb))
		{
			continue;
		}
		
		var hit = ee.aabb.vs_ray(pos, _dir);
		
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

function play_interact_sound (_hit)
{
	mom.achannels.office_ui.play_sound(_hit ? sfx_interact_success : sfx_interact_null, .25);
}

env_surf = -1;
function render ()
{
	var plr = mom.player;
	var t = mom.timer;
	mom.mat_3d_view = mom.move_camera_to_player(plr, t.a, t.time);

	mom.view.push_stack(mom.mat_3d_view);
	mom.proj.push_stack(mom.mat_3d_proj);

	gpu_push_state();
	gpu_set_ztestenable(true);
	gpu_set_zwriteenable(true);
	gpu_set_alphatestenable(true);
	gpu_set_cullmode(cull_counterclockwise);
	gpu_set_texfilter(true);

	var _spr_tex = tex_env_test_1;
	
	if (!surface_exists(env_surf))
	{
		env_surf = surface_create(2048, 2048);
	}
	
	gpu_push_state();
	gpu_set_ztestenable(false);
	gpu_set_zwriteenable(false);
	gpu_set_alphatestenable(true);
	
	mom.push_surface_target(env_surf);
	draw_clear(c_black);
	draw_sprite(tex_env_test_1, 0, 0, 0);
	//draw_sprite_stretched_ext(
	//	spr_temp, 0,
	//	64, 64,
	//	2048 - 128, 2048 - 128,
	//	c_white, .05
	//);
	//draw_sprite_stretched_ext(
	//	spr_temp, 0,
	//	0, 0,
	//	2048, 2048,
	//	c_white, .05
	//);
	
	mom.pop_surface_target();
	gpu_pop_state();
	
	draw_env_part(0, surface_get_texture(env_surf), 20);
	
	//draw_env_part(Envmap_dir.front, sprite_get_texture(_spr_tex, 0), 20);
	draw_env_part(Envmap_dir.right, sprite_get_texture(_spr_tex, 1), 20);
	draw_env_part(Envmap_dir.back,  sprite_get_texture(_spr_tex, 2), 20);
	draw_env_part(Envmap_dir.left,  sprite_get_texture(_spr_tex, 3), 20);
	draw_env_part(Envmap_dir.up,    sprite_get_texture(_spr_tex, 4), 20);
	draw_env_part(Envmap_dir.down,  sprite_get_texture(_spr_tex, 5), 20);

	for (var i = 0, len = array_length(room_ents); i < len; i++)
	{
		var e = room_ents[i];
			
		if (!e.cleanup)
		{
			e.draw();
		}
	}

	gpu_pop_state();
	mom.view.pop_stack();
	mom.proj.pop_stack();
	
	if (hud_display_enabled)
	{
		gpu_push_state();
		var cx = mom.ref_w >> 1;
		var cy = mom.ref_h >> 1;
	
		if (entity_of_interest != -1)
		{
			var scr_spc_p = world_to_screen(
				entity_of_interest.x,
				entity_of_interest.y,
				entity_of_interest.z,
				mom.mat_3d_view,
				mom.mat_3d_proj
			);
	
			if (scr_spc_p[2] > 0)
			{
				var gx = (scr_spc_p[0] * .5 + .5) * mom.ref_w;
				var gy = (scr_spc_p[1] * .5 + .5) * mom.ref_h;
		
				draw_sprite_ext(
					spr_interact_placeholder, 0,
					gx + (cx - gx) * .25,
					gy + (cy - gy) * .25,
					1, 1,
					0,
					c_white,
					0.5
				);
			}
		}
	
		// crosshair
		mom.world.push_stack(matrix_build(cx, cy, 0, 0,0,0, 1,1,1));
	
		var dr = plr.get_look_vector(10);
		var cp = world_to_screen(dr[0], dr[1], dr[2], mom.mat_3d_view, mom.mat_3d_proj);

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
	
		draw_crosshair(cp[0] * cx, cp[1] * cy, crosshair_ind_x, crosshair_ind_y);
	
		mom.world.pop_stack();
	
		gpu_pop_state();
	}
	
	cctv_flipper.draw();
	
	gpu_push_state();
		gpu_set_ztestenable(false);
		gpu_set_zwriteenable(false);
		gpu_set_alphatestenable(false);
		gpu_set_blendmode(bm_subtract);
		gpu_set_texfilter(true);
		draw_sprite_stretched_ext(spr_vinyet, 0, 0, 0, mom.ref_w, mom.ref_h, $8f8f8f, 1.);
	gpu_pop_state();
}

function tick ()
{
	var dr = mom.player.get_look_vector(1);
	
	entity_of_interest = find_interactable(mom.entities, dr);
	
	while (mom.input.vore_press("office.interact"))
	{
		switch (instanceof(entity_of_interest))
		{
			case "Fpw_Entity":
				entity_of_interest.interact(mom);
				if (entity_of_interest.has_interact_sound)
				{
					play_interact_sound(true);
				}
				break;
			default:
				play_interact_sound(false);
				break;
		}
	}
}

function init ()
{
	with (mom)
	{
		set_mouse_grab(true);
		add_entity(other.room_ents);
		add_entity(other.cctv_flipper);
	
		input.add_input("office", "interact", mb_left, "mouse");
	
		input.add_input("odebug", "togglepanic", vk_space, "keyboard");
		input.add_input("odebug", "plr_w", ord("W"), "keyboard");
		input.add_input("odebug", "plr_s", ord("S"), "keyboard");
		input.add_input("odebug", "plr_a", ord("A"), "keyboard");
		input.add_input("odebug", "plr_d", ord("D"), "keyboard");
		input.add_input("odebug", "plr_u", vk_shift, "keyboard");
		input.add_input("odebug", "plr_b", vk_control, "keyboard");
		input.add_input("odebug", "plr_resetpos", ord("1"), "keyboard");
	}
}

function set_interaction (_state)
{
	mom.input.set_group_enable("odebug", _state);
	mom.input.set_group_enable("office", _state);
	mom.set_mouse_grab(_state);
	
}

function switch_from ()
{
	set_interaction(false);
}

function switch_to ()
{
	hud_display_enabled = true;
	set_interaction(true);
}

crosshair_ind_x = 0;
crosshair_ind_y = 0;

function draw_crosshair (_x, _y, _ix, _iy)
{
	var cr_spr = spr_crosshairs;
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
		cr_spr, 0,
		cr_ix, cr_iy, cr_w, cr_h,
		floor(_x - cr_ofs_x), floor(_y - cr_ofs_y),
		1., 1.,
		c_white, 1.
	);
	
	gpu_pop_state();
}

var cctv_toggle = (new Fpw_Entity())
	.set_aabb(8, 6, 5)
	.set_loc_no_history(0, 6, -15);

cctv_toggle.has_interact_sound = false;

cctv_toggle.interact = function ()
{
	if (cctv_flipper.can_flip())
	{
		set_interaction(false);
		mom.can_pause = false;
		cctv_flipper.flip_up();
		hud_display_enabled = false;
	}
}

cctv_flipper = new Fpw_CctvFlipper();
cctv_flipper.flip_up_end = function ()
{
	mom.change_view("cctv");
}

room_ents = [
	(new Fpw_Entity())
		.set_aabb(.5, 10, 5)
		.set_loc_no_history(-10, 0, 0),
		
	(new Fpw_Entity())
		.set_aabb(.5, 10, 5)
		.set_loc_no_history(10, 0, 0),
		
	(new Fpw_Entity())
		.set_aabb(1.5, 2, 1.5)
		.set_loc_no_history(9, -.5, -3),
		
	cctv_toggle,
];

