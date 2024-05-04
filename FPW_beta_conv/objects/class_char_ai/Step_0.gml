/// @desc
if (!is_enabled)
	exit;

var l_obj = obj_labyrinth_visuals;

if (cooldown <= 0)
{
	cooldown = cooldown_time;
	
	var sect_info = l_obj.map_info[?current_sector];
	var sect_dist = ds_map_exists(sect_info, "plr_dist") ? sect_info[?"plr_dist"] : -1;
	
	if (ds_map_exists(sect_info, "connections"))
	{
		var choices = [];
		var connections = sect_info[?"connections"];
		
		// add sectors to the list more times depending on the further/closer bias
		// todo: add a bias for when rooms are the same distance? or just use one of the two
		// unsure
		// could be cleaner
		var cn_sz = ds_list_size(connections);
		for (var i = 0; i < cn_sz; i++)
		{
			var sect_poss_name = connections[|i];
			var sect = l_obj.map_info[?sect_poss_name];
			
			var dist = ds_map_exists(sect, "plr_dist") ? sect[?"plr_dist"] : -1;
			var times = 1;
			
			if (dist != -1 && sect_dist != -1)
				times = dist > sect_dist ? bias_further : bias_closer;
			
			// check against allowed rooms. if its in there, you can add it to the choices
			// or if no allowed rooms are defined
			var is_allowed = allowed_rooms != -1 && ds_map_exists(allowed_rooms, sect_poss_name);
			if (is_allowed || allowed_rooms == -1)
			{
				repeat (times)
					array_push(choices, sect_poss_name);
			}

			//if (dist != -1 && sect_dist != -1)
			//{
			//	var ind = array_size(choices);
				
			//	if (dist != sect_dist)
			//		repeat (dist > sect_dist ? bias_further : bias_closer)
			//			choices[ind] = sect_poss_name;
			//	else
			//		choices[ind] = sect_poss_name;
				
			//}
			
		}
		
		//target_sector = connections[|max(irandom(ds_list_size(connections) - 1), 0)];
		if (array_size(choices) != 0)
		{
			var targ_choice = choices[max(irandom(array_size(choices) - 1), 0)];
			target_sector = targ_choice;
			
		}
		
	}
	
}
