/// @desc drawing the screen then debug stuff
var winw = window_get_width();
var winh = window_get_height();
var guiw = display_get_gui_width();
var guih = display_get_gui_height();
var apos = application_get_position();

// okay stop drawing to the app surface
// also draw the screen if the gui was being added to
// the appsurface
if (gui_draw_to_appsurface) 
{
	surface_reset_target(); 
	draw_screen(winw, winh, guiw, guih, apos);
	
}

#region debug info
if (DEBUG) begin
	display_set_gui_size(winw, winh);

	display_set_gui_maximise(1, 1, 0, 0);

	if (DEBUG_SHOW_FPS)
	{
		debug_push_string("fps", fps);
		debug_push_string("fps_real", fps_real);
	
		if (!ds_stack_empty(_G.debug_text_stack))
		{
			draw_push_state();
		
			draw_set_colour(c_yellow);
			draw_set_font(_G.font_debug);
			draw_set_halign(_G.debug_text_halign);
			draw_set_valign(_G.debug_text_valign);
	
			var xpos, ypos;
	
			switch (_G.debug_text_halign)
			{
				default:
				case fa_left:
					xpos = 32;
					break;
		
				case fa_right:
					xpos = winw - 32;
					break;
		
			}
	
			switch (_G.debug_text_valign)
			{
				default:
				case fa_top:
					ypos = 32;
					break;
		
				case fa_bottom:
					ypos = winh - 32;
					break;
		
			}
	
			var outStr = "";
			do {
				var s = ds_stack_pop(_G.debug_text_stack);
				outStr += s;
			} until (ds_stack_empty(_G.debug_text_stack))
		
			var cccc = draw_get_colour();
			draw_text_colour(
				xpos, ypos, 
				outStr,
				cccc, cccc,
				cccc, cccc,
				0.75
			);
	
			draw_pop_state();
	
		}
		
	}
	scr_gui_reset(apos);

end

#endregion
