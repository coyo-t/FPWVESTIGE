/// @desc
model_monitor = model_load_vbm(BASEPATH+"mdl/monitor_screen.vbm", _G.vform_shadeless, true);
screen_surface = -1;
screen_size = 256;
model_size = 2560/5;

screen_z = empty_monitor_depth.depth;

scanline_shade = make_colour_shade(32);

var backgrounds = [
	__spr_bg_test,
	__spr_dreaded,
	spr_stats_bg_radiance,
	spr_stats_bg_earthis,
	spr_stats_bg_coyote,
	spr_stats_bg_happyjackal,
];

background = backgrounds[irandom(array_size(backgrounds) - 1)];

startup_fade = 1.;
startup_anim = spr_stats_startup;
startup_timer = -1;
startup_timer_end = sprite_get_number(startup_anim);
startup_ended = false;
