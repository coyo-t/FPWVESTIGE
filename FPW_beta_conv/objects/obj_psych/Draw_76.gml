/// @desc
if (!madness_hit_max)
{
	madness_target += madness_rate * dt();
	madness_target = clamp(madness_target, 0, madness_max);

	madness = lerp_dt(madness, madness_target, math_get_epsilon());
	madness = clamp(madness, 0, madness_max);

}

var last_max = madness_hit_max;

if (madness_target >= madness_max || madness >= madness_max)
{
	madness_hit_max = true;
	madness = madness_max;
	madness_target = madness_max;
}

if (last_max != madness_hit_max)
{
	var s = audio_play_sound(sfx_haluc_shattarm, 5, false);
	audio_sound_gain(s, .6, 0);
	audio_sound_pitch(s, 0.75);
	
}

madness_normalized = madness / madness_max;

if (madness > 1)
{
	ds_stack_push(obj_screen_decor.draw_stack, madness_draw_routine);
}
