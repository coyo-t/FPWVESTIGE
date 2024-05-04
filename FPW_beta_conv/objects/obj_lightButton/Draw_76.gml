/// @desc
if (flicker_queue) {
	flicker_queue = false;
	timeline_position = 0;
	image_alpha = 0;
	alpha_active = false;
	sound_buzz_pitch_vari = sound_buzz_pitch_vari_base + random_range(-0.05, 0.05);
}
