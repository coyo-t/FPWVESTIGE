/// @desc
//startup_ended = startup_timer == startup_timer_end;

//startup_timer = animate_and_return(startup_anim, startup_timer, 1);
//startup_timer = min(startup_timer, startup_timer_end);
			
//startup_fade -= dt() * 2 * startup_ended;
//startup_fade = max(startup_fade, 0.);

if (!is_enabled)
	exit;

var seq_exist = layer_sequence_exists(show_layer, show_seq_id);

if (obj_labyrinth_visuals.state == room_states.lizz)
{
	var pos = obj_panorama_labyrinth.dist_pos();

	is_tv_on ^= bounds.vs_point(pos[0], pos[1]) && meta_master.get_inp("mb_left_down");
	
}

if (is_tv_on)
{
	if (layer_sequence_is_finished(show_seq_id) || !seq_exist)
		select_new_show();

	obj_psych.affect_rate(-25);
	
} else {
	if (seq_exist)
		layer_sequence_destroy(show_seq_id);
}

drain_affect = (is_tv_on)
	? drain_affect_max
	: lerp_dt(drain_affect, 0, 0.24);

obj_power.affect_drain(drain_affect);

debug_push_string("draindelta", drain_affect);
