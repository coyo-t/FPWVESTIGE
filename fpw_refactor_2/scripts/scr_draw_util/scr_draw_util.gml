///@arg sprite
///@arg frame
///@arg delta
function animate_and_return (_spr, _frame, _delta)
{
	return _frame + (sprite_get_speed(_spr) * _delta * DT);
}


_G.draw_state_stack = ds_stack_create();

function draw_push_state ()
{
	ds_stack_push(
		_G.draw_state_stack, 
		draw_set_colour, draw_get_colour(),
		draw_set_alpha,  draw_get_alpha(),
		draw_set_font,   draw_get_font(),
		draw_set_halign, draw_get_halign(),
		draw_set_valign, draw_get_valign()
	);
}


function draw_pop_state ()
{
	while (!ds_stack_empty(_G.draw_state_stack))
	{
		(ds_stack_pop(_G.draw_state_stack))(ds_stack_pop(_G.draw_state_stack));
	}
}

///@func draw_cross(x, y, radius)
function draw_cross (_x, _y, _r)
{
	_x = floor(_x);
	_y = floor(_y);
	draw_line(_x - _r, _y - _r, _x + _r, _y + _r);
	draw_line(_x + _r, _y - _r, _x - _r, _y + _r);
}

///@func draw_cross_ext(x, y, x_radius, y_radius)
function draw_cross_ext (_x, _y, _xr, _yr)
{
	_x = floor(_x);
	_y = floor(_y);
	draw_line(_x - _xr, _y - _yr, _x + _xr, _y + _yr);
	draw_line(_x + _xr, _y - _yr, _x - _xr, _y + _yr);
}

///@func draw_plus(x, y, radius)
function draw_plus (_x, _y, _r)
{
	_x = floor(_x);
	_y = floor(_y);
	draw_line(_x, _y - _r, _x, _y + _r);
	draw_line(_x - _r, _y, _x + _r, _y);
}


function draw_get_colour_argb ()
{
	gml_pragma("forceinline");
	return (((floor(draw_get_alpha() * $ff) & $ff) << 24) | draw_get_colour());
}
