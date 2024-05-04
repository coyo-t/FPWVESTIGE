//if (surface_get_width(appsurf) != draw_prop.w || surface_get_height(appsurf) != draw_prop.h)
//{
//	fpw.resize_appsurf(draw_prop.w, draw_prop.h, true);
//}

if (draw_prop.owin_w != window_get_width() or draw_prop.owin_h != window_get_height())
{
	compute_draw_prop();
	display_set_gui_maximise();
}
draw_prop.owin_w = window_get_width();
draw_prop.owin_h = window_get_height();
