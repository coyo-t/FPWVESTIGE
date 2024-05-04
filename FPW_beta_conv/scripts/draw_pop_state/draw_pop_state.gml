function draw_pop_state() {
	if (!ds_stack_empty(_G.draw_state_stack))
	{
		var _state = ds_stack_pop(_G.draw_state_stack);

		draw_set_colour(_state[0]);
		draw_set_alpha(_state[1]);
		draw_set_font(_state[2]);
		draw_set_halign(_state[3]);
		draw_set_valign(_state[4]);
		_G.draw_model_colour = _state[5];
		_G.draw_model_alpha  = _state[6];
	
	}



}
