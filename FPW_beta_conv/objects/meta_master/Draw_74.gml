/// @desc set the draw target to the appsurface... again
/// This is so that gui elements appear on the appsurface
/// If that's disabled tho just draw the appsurface

var winw = window_get_width();
var winh = window_get_height();
var guiw = display_get_gui_width();
var guih = display_get_gui_height();
var apos = application_get_position();

if (gui_draw_to_appsurface) 
{
	surface_set_target(application_surface);
	
} else {
	draw_screen(winw, winh, guiw, guih, apos);
	
}
