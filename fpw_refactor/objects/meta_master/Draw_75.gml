var as_w = surface_get_width(appsurf);
var as_h = surface_get_height(appsurf);

var ww = window_get_width();
var wh = window_get_height();

var dp = draw_prop;

if (keyboard_check_pressed(vk_f12))
{
	save_screenshot();
}

gpu_push_state();
gpu_set_blendenable(0);
gpu_set_texfilter(dp.use_texfilter);

draw_surface_ext(
	appsurf, 
	dp.pos_x, dp.pos_y,
	dp.ratio_x, dp.ratio_y,
	0,
	c_white, 1.
);

gpu_pop_state();

//draw_set_colour(c_green);

draw_set_colour(c_white);
