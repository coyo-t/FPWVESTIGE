#region
function create_view (_name, _obj)
{
	with (instance_create_layer(0, 0, layer, _obj))
	{
		other.views[$ _name] = self;
		mom = other;
		init();
		return self;
	}
}

function set_mouse_grab (_state)
{
	grab_mouse = _state;
	
	if (_state)
	{
		window_set_cursor(cr_none);
		ignore_next_mouse_grab_update = true;
		
		//old_mouse_x = display_mouse_get_x();
		//old_mouse_y = display_mouse_get_y();
	}
	else
	{
		window_set_cursor(cr_default);
		
		//display_mouse_set(old_mouse_x, old_mouse_y);
	}
}

function update_mouse_grab ()
{
	var mofx = window_get_x();
	var mofy = window_get_y();
	
	var mw = (window_get_width() >> 1);
	var mh = (window_get_height() >> 1);
	
	var mx = ((display_mouse_get_x() - mofx) - mw) * ref_a;
	var my = ((display_mouse_get_y() - mofy) - mh) * ref_a;
	
	display_mouse_set(mw + mofx, mh + mofy);
	
	if (ignore_next_mouse_grab_update)
	{
		mouse_dx = 0;
		mouse_dy = 0;
		mx = 0;
		my = 0;
		ignore_next_mouse_grab_update = false;
	}
	
	mouse_dx = (mouse_dx + (mx * mouse_retard)) * .5;
	mouse_dy = (mouse_dy + (my * mouse_retard)) * .5;
	
}

function turn_player ()
{
	var tm = player.panic.get_fac(timer.a);
	player.turn(mouse_dx, mouse_dy);
	player.ar = clamp(player.ar - mouse_dx * (.15 + (.2 * tm)), -10, 10);
}

function move_listener (_x, _y, _z, _ap, _ay)
{
	var am = matrix_build(0,0,0, _ap, _ay, 0, 1,1,1);
	audio_listener_position(-_x, -_y, _z);
	
	var axis_y = matrix_transform_vertex(am, 0, -1, 0);
	var axis_z = matrix_transform_vertex(am, 0, 0, 1);

	audio_listener_orientation(axis_z[0], axis_z[1], axis_z[2], axis_y[0], axis_y[1], axis_y[2]);
}

function move_camera_to_player (plr, a, t)
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
	
	var bobx = (sin(t * pi * .9)  * (.05 + pfac * .5)) + (1.25 * pfac);
	var boby = (cos(t * pi * .45) * (.1 + pfac * 1.8));
	
	mats.push(matrix_build(0, 0, 0, bobx,boby,-boby * 2., 1,1,1))
	
	var plrx = plr.tlerp(plr.x, plr.ox, a);
	var plry = plr.tlerp(plr.y, plr.oy, a);
	var plrz = plr.tlerp(plr.z, plr.oz, a);
	
	mats.push(matrix_build(0, 0, 0, 0,0, plr.tlerp(plr.ar, plr.oar, a), 1,1,1));
	mats.push(matrix_build(0, 0, 0, plr.ap,plr.ay,0, 1,1,1));
	mats.push(matrix_build_position(plrx, plry, plrz));
	
	var m = mats.top();
	mats.pop_stack();

	move_listener(plrx, plry, plrz, plr.ap, plr.ay)
	
	return m;
}

function set_paused (_state)
{
	if (!can_pause)
	{
		return;
	}
	
	is_paused = _state;
	
	if (_state)
	{
		grab_mouse_paused = grab_mouse;
		set_mouse_grab(false);
		timer.soft_pause();
		timer.tickroutine = tick_paused;
		achannels_set_pause(true);
	}
	else
	{
		set_mouse_grab(grab_mouse_paused);
		ignore_next_mouse_grab_update = true;
		grab_mouse_paused = -1;
		timer.soft_unpause();
		timer.tickroutine = tick_generic;
		input.flush_all();
		achannels_set_pause(false);
	}
}

function add_entity (_ent)
{
	if (is_array(_ent))
	{
		for (var i=0, len=array_length(_ent); i<len; i++)
		{
			add_entity(_ent[i]);
		}
		
		return;
	}
	_ent.mom = self;
	array_push(entities, _ent);
}

function clean_entity_list ()
{
	for (var i = array_length(entities) - 1; i >= 0; --i)
	{
		var e = entities[i];
		
		if (is_undefined(e) or e == -1)
		{
			array_delete(entities, i, 1);
		}
		
		if (e.cleanup)
		{
			e.free();
			delete e;
			array_delete(entities, i, 1);
		}
	}
}

function free_all_entities ()
{
	for (var i = array_length(entities) - 1; i >= 0; --i)
	{
		var e = entities[i];
		
		if (is_undefined(e) or e == -1)
		{
			continue;
		}
		
		e.free();
		delete e;
	}
}

function change_view (_state)
{
	if (variable_struct_exists(views, _state))
	{
		queued_view = views[$ _state];
	}
}

function draw_pause_screen ()
{
	gpu_push_state();
	
	var wh = ref_w >> 1;
	var hh = ref_h >> 1;
	gpu_set_blendmode(bm_max);
	gpu_set_zwriteenable(false);
	gpu_set_ztestenable(false);
	draw_sprite(spr_pause_bkd, 0, ref_w, ref_h);

	gpu_set_blendmode(bm_normal);
	gpu_set_zwriteenable(true);
	gpu_set_ztestenable(true);
	view_cctv.draw_golem_symbol(view_cctv.mdl_golem, wh, hh, 256, 256, TIME);
	
	gpu_set_zwriteenable(false);
	gpu_set_ztestenable(false);
	
	gpu_set_blendmode(bm_subtract);
	draw_rectangle_colour(
		0,0,
		ref_w,ref_h,
		c_white, c_white,
		c_grey, c_grey,
		false
	);
	
	gpu_set_blendmode(bm_max);
	draw_sprite(spr_pause_text, 0, wh, hh);
	//gpu_set_blendmode(bm_subtract);
	//draw_rectangle_colour(
	//	0,0,
	//	ref_w,ref_h,
	//	c_blue, c_blue,
	//	c_teal, c_teal,
	//	false
	//);
	gpu_pop_state();
	//draw_text(257, 32, "PAUSE");
}

function achannels_set_pause (_state)
{
	var chans = variable_instance_get_names(achannels);
		
	for (var i = 0; i < array_length(chans); i++)
	{
		var ch = achannels[$ chans[i]];
		
		if (ch.paused)
		{
			continue;
		}
		
		if (_state)
		{
			audio_pause_sound(ch.__sfx);
		}
		else
		{
			audio_resume_sound(ch.__sfx);
		}
	}
}

function __change_view ()
{
	current_view.switch_from();
	queued_view.switch_to();
	
	current_view = queued_view;
	queued_view = -1;
	
	input.flush_all();
}

function push_surface_target (_srf)
{
	proj.push_stack();
	view.push_stack();
	gpu_push_state();
	surface_set_target(_srf);
}

function pop_surface_target ()
{
	surface_reset_target();
	gpu_pop_state();
	proj.pop_stack();
	view.pop_stack();
}

#region tick update funcs
function tick_generic (_mom)
{
	while (input.vore_press("main.pause"))
	{
		set_paused(is_paused ^ 1);
		return;
	}
	
	if (queued_view != -1)
	{
		__change_view();
	}
	
	if (tick_entities)
	{
		for (var i = 0, len = array_length(entities); i < len; i++)
		{
			var e = entities[i];
			
			if (!e.cleanup)
			{
				e.tick();
			}
		}
	}
	
	current_view.tick();
}

function tick_paused (_mom)
{
	while (input.vore_press("main.pause"))
	{
		set_paused(is_paused ^ 1);
		return;
	}
}

#endregion
#endregion

ref_w = 1280;
ref_h = 720;
ref_a = 1. / (ref_w / ref_h);

is_paused = false;
can_pause = true;
pause_save_mouse_pos = true;

mats  = new MatrixStack();
world = new MatrixStack(matrix_world);
view  = new MatrixStack(matrix_view);
proj  = new MatrixStack(matrix_projection);

mat_3d_proj = matrix_build_projection_perspective_fov(fov_h2v(90, ref_w, ref_h), ref_w/ref_h, 0.01, 2500);
mat_3d_view = matrix_build_position(0, 0, 10);

mat_2d_view = matrix_build_ps(-(ref_w>>1), ref_h>>1, 0, 1, -1, 1);
mat_2d_proj = matrix_build_projection_ortho(ref_w, ref_h, 0, 25000);

timer = new Timer(20);
timer.tickroutine = tick_generic;

views = {};

grab_mouse = false;
grab_mouse_paused = -1;
ignore_next_mouse_grab_update = true;

mouse_retard = .22;
mouse_dx = 0;
mouse_dy = 0;
old_mouse_x = 0;
old_mouse_y = 0;

entities = [];
tick_entities = true;

input = new InputManager();

view_visible = true;
view_set_visible(0, true);
view_set_wport(0, ref_w);
view_set_hport(0, ref_h);

player = new Fpw_Player();

add_entity(player);

view_office = create_view("office", obj_mg_view_office);
view_cctv   = create_view("cctv", obj_mg_view_cctv);

current_view = view_office;
queued_view = -1;

input.add_input("main", "pause", vk_insert, "keyboard");

achannels = {
	office_ui: new AudioChannel(0),
	transitions: new AudioChannel(0),
};

texture_prefetch("main_gameplay");
