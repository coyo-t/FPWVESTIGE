/// @desc setup at start after create

var cyc_inf = obj_cycle_manager.current_cycle_info;
var enable = ds_map_exists(cyc_inf, "overnight_enabled") ? cyc_inf[?"overnight_enabled"] : true;

if (enable)
{
	var lvl = cyc_inf[?"char_levels"];

	if (ds_map_exists(lvl, char_name))
	{
		aggro_level = lvl[?char_name];
	} else {
		//overnight's aggresion is the mean of every other character's
		var accumulator = 0;
		var count = 0;
		var myid = id;

		with (class_char_ai)
		{
			if (id != myid)
			{
				accumulator += aggro_level;
				count++;
			}
		}

		aggro_level = accumulator / count;
		aggro_level_normal = aggro_level / AI_MAX_LEVEL;

		madness_increase = (1. - aggro_level_normal) * 128;

		//The base time Overnight spends in their room
		cooldown_in_time_base = 60;
		cooldown_in_time = cooldown_in_time_base - (aggro_level_normal * cooldown_in_time_base);

		cooldown = random(cooldown_in_time);
	
	}
	
} else {
	enabled = false;
}
