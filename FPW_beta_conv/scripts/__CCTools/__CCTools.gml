#macro _G global
_G.time_scale = 1;


function shiftCol (argument0, argument1) begin
	return (argument0 >> argument1) & 0x0000ff;
end


function dt () begin
	return (delta_time / 1000000) * global.time_scale;
end


function set_time_scale (timescale) begin
	_G.time_scale = max(timescale, 0);
end


function time () begin
	return current_time / 1000;
end


//#define real_time
//return current_time / 1000;


function rb2br (rgb_hex) begin
	return make_colour_rgb(shiftCol(rgb_hex, 16), shiftCol(rgb_hex, 8), shiftCol(rgb_hex, 0));
end


function shader_send (uniform_name, uniform_value) begin
	shader_set_uniform_f(shader_get_uniform(shader_current(), string(uniform_name)), uniform_value);
end


function shader_send_vec2 (uniform_name, arg_array) begin
	var sh = shader_get_uniform(shader_current(), string(uniform_name));
	shader_set_uniform_f(sh, arg_array[0], arg_array[1]);
end


function shader_send_vec3 (uniform_name, arg_array) begin
	var sh = shader_get_uniform(shader_current(), string(uniform_name));
	shader_set_uniform_f(sh, arg_array[0], arg_array[1], arg_array[2]);
end


function shader_send_vec4 (uniform_name, arg_array) begin
	var sh = shader_get_uniform(shader_current(), string(uniform_name));
	shader_set_uniform_f(sh, arg_array[0], arg_array[1], arg_array[2], arg_array[3]);
end


// uhh get back to this one .-.
//#define shader_send_colour
//var _uniform = shader_get_uniform(shader_current(),  string(argument[0]));
//var _argType = typeof(argument[1]);

//if (argument_count == 2 && _argType == "number")
//{
//	var crb = shiftCol(argument[1], 0);
//	var cg =  shiftCol(argument[1], 8);
//	var cbr = shiftCol(argument[1], 16);

//	shader_set_uniform_f(_uniform, crb / 255.0, cg / 255.0, cbr / 255.0);
//	exit;
//}
//else if (argument_count == 2 && _argType == "array")
//{
//	var _c = argument[1];
//	shader_set_uniform_f(_uniform, _c[0] / 255.0, _c[1] / 255.0, _c[2] / 255.0);
//	exit;
//}
//else if (argument_count > 2)
//{
//	shader_set_uniform_f(_uniform, argument[1], argument[2], argument[3]);
//	exit;
//} else {
//	show_error("Expected 2-4 arguments, got " + string(argument_count), true);
//	exit;
//}


function print () begin
	if (argument_count == 1)
	{
		show_debug_message(argument[0]);
		exit;

	} else {
		for (var i = 0; i < argument_count; i++)
		{
			show_debug_message(argument[i]);
		}
	}
end


function printf () begin
	var _s = string(argument[0]);

	if (argument_count == 1)
	{
		show_debug_message(_s);
		exit;

	} else {
		for (var i = 1; i < argument_count; i++)
		{
			_s = string_replace(_s, "%s", string(argument[i]));
		}
	}

	show_debug_message(_s);

end


function stringf () begin
	var _s = string(argument[0]);

	if (argument_count == 1)
	{
		show_debug_message(_s);
		exit;

	} else {
		for (var i = 1; i < argument_count; i++)
		{
			_s = string_replace(_s, "%s", string(argument[i]));
		}
	}

	return _s;

end


function mouse_x_real () begin
	var app = application_get_position();

	var aw = surface_get_width(application_surface);
	var size = app[2] - app[0];

	var px = ((display_mouse_get_x() - window_get_x()) - app[0]) / size;

	return floor((px * aw) + 0.5);

end


function mouse_y_real () begin
	var app = application_get_position();

	var ah = surface_get_height(application_surface);
	var size = app[3] - app[1];

	var py = ((display_mouse_get_y() - window_get_y()) - app[1]) / size;

	return floor((py * ah) + 0.5);

end


function mouse_x_real_offset () begin
	return mouse_x_real() + camera_get_view_x(view_camera[view_current]);
end


function mouse_y_real_offset () begin
	return mouse_y_real() + camera_get_view_y(view_camera[view_current]);
end


function wrap (value, _min, _max) begin
	return (((value + _min) + (_max + 1)) % (_max + 1)) - _min;
end


function wrap_exc (value, _min, _max) begin
	return (((value + _min) + _max) % _max) - _min;
end


function draw_rectangle_size (_x, _y, _w, _h, _outline) begin
	draw_rectangle(_x, _y, _x + (_w - 1), _y + (_h - 1), _outline);
end


function lerp_dt (value1, value2, fac) begin
	return lerp(value1, value2, 1 - power(fac, dt()));
end


function lerp_dt_1d (value1, value2, fac) begin
	return lerp(value1, value2, 1 - power(1 / fac, dt()));
end


function t2m1 (_x) begin
	return (_x * 2) - 1;
end


function a1d2 (_x) begin
	return (_x + 1) * 0.5;
end


function array_size (arr) begin
	return array_length(arr);
end

