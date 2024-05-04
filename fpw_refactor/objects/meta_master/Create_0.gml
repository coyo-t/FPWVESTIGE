event_inherited();

if (!persistent)
{
	exit;
}

#region window drawing related shit
enum WindowScaleMode
{
	centre,
	fit,
	upscale,
	noop,
	manual
}

appsurf_upscale_mode = WindowScaleMode.fit;

display_set_gui_maximise();

application_surface_draw_enable(false);

function compute_draw_prop ()
{
	if (appsurf_upscale_mode != WindowScaleMode.manual)
	{
		var as_w = draw_prop.w;
		var as_h = draw_prop.h;

		var ww = window_get_width();
		var wh = window_get_height();
		
		var ratio_x, ratio_y;
		var dpos_x, dpos_y;

		switch (appsurf_upscale_mode)
		{
			default:
			case WindowScaleMode.fit:
				//scaling
				var ratio_x = ww / as_w;
				var ratio_y = wh / as_h;

				if (ratio_x < ratio_y)
				{
					ratio_y = ratio_x;
				}
				else if (ratio_y < ratio_x)
				{
					ratio_x = ratio_y;
				}
				else
				{
					ratio_x = 1;
					ratio_y = 1;
				}

				//position
				var dpos_x = (ww - (as_w * ratio_x)) >> 1;
				var dpos_y = (wh - (as_h * ratio_y)) >> 1;
			break;
	
			case WindowScaleMode.upscale:
				dpos_x = 0;
				dpos_y = 0;
		
				ratio_x = ww/as_w;
				ratio_y = wh/as_h;
		
			break;
	
			case WindowScaleMode.centre:
				ratio_x = 1;
				ratio_y = 1;
			
				dpos_x = (ww - as_w) >> 1;
				dpos_y = (wh - as_h) >> 1;
			
			break;
		
			case WindowScaleMode.noop:
				ratio_x = 1;
				ratio_y = 1;
				dpos_x = 0;
				dpos_y = 0;
			break;
		
		}
	
		draw_prop.ratio_x = ratio_x;
		draw_prop.ratio_y = ratio_y;
		draw_prop.pos_x   = dpos_x;
		draw_prop.pos_y   = dpos_y;
	}
}

///resize_appsurf(new_width, new_height, *set_texfilter)
function resize_appsurf (new_w, new_h, set_filter)
{
	surface_resize(appsurf, new_w, new_h);
	draw_prop.w = new_w;
	draw_prop.h = new_h;
	compute_draw_prop();
	display_set_gui_maximise();
	
	if (set_filter != undefined)
	{
		draw_prop.use_texfilter = set_filter;
	}
}

draw_prop = {
	owin_w: window_get_width(),
	owin_h: window_get_height(),
	pos_x: 0,
	pos_y: 0,
	ratio_x: 1,
	ratio_y: 1,
	
	w: surface_get_width(appsurf),
	h: surface_get_height(appsurf),
	
	use_texfilter: true,
	border_colour: $000000,
};

window_set_colour(draw_prop.border_colour);

#region input
function get_mouse_x ()
{
	return ((display_mouse_get_x() - window_get_x()) - draw_prop.pos_x) / draw_prop.ratio_x;
}

function get_mouse_y ()
{
	return ((display_mouse_get_y() - window_get_y()) - draw_prop.pos_y) / draw_prop.ratio_x;
}


#endregion

function save_screenshot ()
{
	var ssurf = surface_create(appsurf_w, appsurf_h);
	surface_set_target(ssurf);
		draw_clear_alpha(c_black, 1.);
		gpu_push_state();
		gpu_set_blendenable(0);
		gpu_set_colourwriteenable(1,1,1,0);
		draw_surface(appsurf, 0, 0);
		gpu_pop_state();
	surface_reset_target();
	
	var date = date_current_datetime();
	var fname = (
		build_year_week_tag()+
		";"+tostr(date_get_minute(date))+
		";"+tostr(date_get_second(date))
	);
	surface_save(ssurf, SCREENSHOT_SAVE_LOC+fname+".png");
	
	surface_free(ssurf);
}

#endregion

trans = new MatrixStack(-1);
trans[$"world"] = new MatrixStack(matrix_world);
trans[$"view"]  = new MatrixStack(matrix_view);
trans[$"proj"]  = new MatrixStack(matrix_projection);

function build_year_week_tag ()
{
	var date = date_current_datetime();
	return tostr(date_get_year(date) - 2000)+"w"+tostr(date_get_week(date));
}

debug_string = new MetaModule_DebugString(self);

audio_master_gain(.75);

if (DEBUG)
{
	show_debug_overlay(0);
	audio_debug(0);
}
