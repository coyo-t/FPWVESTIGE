mats = fpw.trans;

timer = new Timer(20);

ref_w = 1280;
ref_h = 720;

mat_3d_view = matrix_build(0, 0, 5, 0,0,0, 1,1,1);
mat_3d_proj = -1;

function rebuild_proj_mat (_fov)
{
	mat_3d_proj = matrix_build_projection_perspective_fov(
		fov_h2v(_fov, appsurf_w, appsurf_h),
		appsurf_w / appsurf_h,
		0.01,
		20000
	);
}

rebuild_proj_mat(90);

mat_2d_view = matrix_build_ps(-ref_w >> 1, -ref_h >> 1, 0, 1,1,1);
mat_2d_proj = matrix_build_projection_ortho(ref_w, ref_h, 0, 32000);

state_room = instance_create_depth(0,0,0, obj_mngr_office_state);
state_room.gs = self;
state_cctv = instance_create_depth(0,0,0, obj_mngr_cctv_state);

//room, cctv, blackout, grunroom
current_state = state_room;
queued_state = -1;

is_paused = false;

input = new InputMap();
input.add("nuke", vk_escape, InputKeyType.keyboard);

view_enabled = true;
view_set_visible(0, true);
view_set_wport(0, ref_w);
view_set_hport(0, ref_h);
view_set_xport(0, 0);
view_set_yport(0, 0);

player = new Fpw_Player();


function get_mouse_prop (_retard)
{
	var mofx = window_get_x();
	var mofy = window_get_y();
	
	var mw = (window_get_width() >> 1);
	var mh = (window_get_height() >> 1);
	
	var mx = ((display_mouse_get_x() - mofx) - mw) / appsurf_r;
	var my = ((display_mouse_get_y() - mofy) - mh) / appsurf_r;
	
	return {
		mw:mw,
		mh:mh,
		mx:mx * _retard,
		my:my * _retard,
		mofx:mofx,
		mofy:mofy,
		rmx: display_mouse_get_x(),
		rmy: display_mouse_get_y()
	};
}

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


function move_camera_to_player (plr, a)
{
	audio_listener_velocity(0, 0, 0);
	mats.push_stack();
	var pfac = plr.panic.get_fac(a);
	
	if (plr.panic.fac > 0)
	{
		var _mat = plr.panic.get_distortion_matrix(a);
		mats.push(_mat);
		audio_listener_velocity(_mat[4] * 500 * pfac, _mat[1] * 500 * pfac, (_mat[10] - 1) * 500 * pfac);
	}
	pfac *= pfac;
	
	var bobx = (sin(TIME * pi * .9)  * (.05 + pfac * .5)) + (1.25 * pfac);
	var boby = (cos(TIME * pi * .45) * (.1 + pfac * 1.8));
	
	mats.push(matrix_build(0, 0, 0, bobx,boby,-boby * 2., 1,1,1))
	
	var plrx = plr.tlerp(plr.x, plr.ox, a);
	var plry = plr.tlerp(plr.y, plr.oy, a);
	var plrz = plr.tlerp(plr.z, plr.oz, a);
	
	//mats.push(matrix_build(0, 0, 0, 0,0, plr.tlerp(plr.ar, plr.oar, a), 1,1,1));
	mats.push(matrix_build(0, 0, 0, 0,0, plr.tlerp(plr.ar, plr.oar, a), 1,1,1));
	mats.push(matrix_build(0, 0, 0, plr.ap,plr.ay,0, 1,1,1));
	mats.push(matrix_build_position(plrx, plry, plrz));
	
	var m = mats.top();
	mats.pop_stack();

	move_listener(plrx, plry, plrz, plr.ap, plr.ay)
	
	return m;
}


///TODO: make me take roll into account too?
function move_listener (_x, _y, _z, _ap, _ay)
{
	var am = matrix_build(0,0,0, _ap, _ay, 0, 1,1,1);
	audio_listener_position(-_x, -_y, _z);
	
	var axis_y = matrix_transform_vertex(am, 0, -1, 0);
	var axis_z = matrix_transform_vertex(am, 0, 0, 1);

	audio_listener_orientation(axis_z[0], axis_z[1], axis_z[2], axis_y[0], axis_y[1], axis_y[2]);
}

grab_mouse = true;
grab_mouse_pause_hold = -1;
grab_mouse_ignore_next = false;
dmx = 0;
dmy = 0;
ograb_mouse = grab_mouse;

function set_cursor (_cr)
{
	window_set_cursor(_cr);
}

function set_grab_mouse (_state, _nohistory)
{
	grab_mouse = _state;
	
	if (grab_mouse)
	{
		set_cursor(cr_none);
		grab_mouse_ignore_next = true;
	}
	else
	{
		set_cursor(cr_default);
	}
	
	if (_nohistory)
	{
		ograb_mouse = _state;
	}
}

set_grab_mouse(true, 0);

function turn_player (plr, gs)
{
	ograb_mouse = grab_mouse;
	var mp = get_mouse_prop(.25);
	
	dmx = (dmx + mp.mx) * .5;
	dmy = (dmy + mp.my) * .5;
	
	var tm = plr.panic.get_fac(gs.timer.a);
	
	if (grab_mouse_ignore_next)
	{
		grab_mouse_ignore_next = false;
		dmx = 0;
		dmy = 0;
	}
	
	if (grab_mouse)
	{
		display_mouse_set(
			mp.mw + mp.mofx,
			mp.mh + mp.mofy
		);
		
		player.turn(dmx, dmy);
		player.ar = clamp(player.ar - dmx * (.15 + (.2 * tm)), -10, 10);
		return;
	}
}


function queue_state_change (_state)
{
	switch (_state)
	{
		case "cctv":
			queued_state = state_cctv;
			break;
		case "room":
			queued_state = state_room;
			break;
		default:
			queued_state = -1;
			break;
	}
}

entities = [];

array_push(entities,
	(new EntityInteractTest(self))
		.set_loc_no_history(-10, 0, 0)
		.set_aabb(.5, 10, 5)
);

array_push(entities,
	(new EntityInteractTest(self))
		.set_loc_no_history(10, 0, 0)
		.set_aabb(.5, 10, 5)
);

array_push(entities,
	(new EntityInteractTest(self))
		.set_loc_no_history(9, -.5, -3)
		.set_aabb(1.5, 2, 1.5)
);

array_push(entities,
	(new EntityInteractTest_cctv_switch(self))
		.set_loc_no_history(0, 6, -15)
		.set_aabb(8, 6, 5)
);