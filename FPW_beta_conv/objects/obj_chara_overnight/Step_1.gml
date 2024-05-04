/// @desc
if (!is_enabled)
	exit;

// Inherit the parent event
event_inherited();

debug_push_string("rate", madness_increase)
if (cctv_viewing())
{
	obj_psych.affect_rate(madness_increase);
	
}
