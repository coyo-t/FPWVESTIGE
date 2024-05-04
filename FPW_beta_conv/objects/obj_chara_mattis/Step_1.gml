/// @desc
if (!is_enabled)
	exit;

// Inherit the parent event
event_inherited();
var cctv_on = obj_cctv.is_cctv_on;

var viewing = cctv_viewing() && current_sector != "interro";
var in_window = inst_lightbutton_m.is_on && current_sector == "interro" && !cctv_on;
var in_door   = inst_lightbutton_l.is_on && current_sector == "airlock_l" && !cctv_on;

if (viewing || in_window || in_door)
{
	var rm = obj_cctv.cctv_current_sector_id.sector_name;

	obj_psych.affect_rate(madness_inc_rate * psyche_levels[?current_sector]); //25;
	
}


