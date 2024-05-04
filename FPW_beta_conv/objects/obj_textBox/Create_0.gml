/// @desc
width  = 0;
height = 0;

function draw () begin
	var _lfont = draw_get_font();
	var _lhalign = draw_get_halign();
	var _lvalign = draw_get_valign();

	var c = is_array(s_colour) && array_length_1d(s_colour) == 4
		? s_colour 
		: [s_colour, s_colour, s_colour, s_colour];

	if (font_exists(s_font))
		draw_set_font(s_font);

	draw_set_halign(s_hallign);
	draw_set_valign(s_vallign);

	var t = gpu_get_texfilter();
	gpu_set_texfilter(s_filter);

	width  = string_width(s_text);
	height = string_height(s_text);

	if (s_useBounds)
	{
		if (image_angle == 0 && (s_xScale == 1 && s_yScale == 1))
		{
			draw_text_ext_colour(
				x, 
				y, 
				s_text, 
				s_lineSep,
				abs(sprite_width),  
				c[0], c[1], c[2], c[3],
				s_alpha	
			);
		
		} else {
			draw_text_ext_transformed_colour(
				x, y,
				s_text,
				s_lineSep, abs(sprite_width),
				s_xScale, s_yScale,
				image_angle,
				c[0], c[1], c[2], c[3],
				s_alpha
			);
		
		}

	} else {
		draw_text_colour(
			x, 
			y, 
			s_text, 
			c[0], c[1], c[2], c[3],
			s_alpha	
		);
		
	}
	
	draw_set_halign(_lhalign);
	draw_set_valign(_lvalign);
	draw_set_font(_lfont);
	gpu_set_texfilter(t);


end

draw();
