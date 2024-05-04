/// @desc
is_enabled = true;
is_on = false;
was_on = false;
is_visible = false;
last_mouse = false;
mouse_down = false;
//mouse_inbounds = false;
sound_buzz = -1;
sound_buzz_volume = 0.75;
sound_buzz_pitch = .8;
sound_buzz_pitch_vari_base = .1;
sound_buzz_pitch_vari = sound_buzz_pitch_vari_base;

light_surface = -1;

alpha_active = true;
flicker_timeline = tmln_light_flicker;
flicker_timeline_max = timeline_max_moment(flicker_timeline) + 1;
timeline_position = flicker_timeline_max;
timeline_pos_nrm = 1;
timeline_running = false;
timeline_index = flicker_timeline;
flicker_queue = false;
