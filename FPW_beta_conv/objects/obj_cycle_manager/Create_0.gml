/// @desc
cycle_info = info_load_json("cycle_info.json");
current_cycle = "e3";
current_cycle_info = cycle_info[?current_cycle];

cycle_time = 0;
cycle_time_normal = 0; // 0-1 normalized version
cycle_time_end = 6*60;
cycle_time_delta = ds_map_exists(current_cycle_info, "time_rate") 
	? current_cycle_info[?"time_rate"]
	: 1.;
