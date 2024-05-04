function draw_push_state() {
	ds_stack_push(
		_G.draw_state_stack, 
		[
			draw_get_colour(),
			draw_get_alpha(),
			draw_get_font(),
			draw_get_halign(),
			draw_get_valign(),
			_G.draw_model_colour,
			_G.draw_model_alpha
		]
	);



}
