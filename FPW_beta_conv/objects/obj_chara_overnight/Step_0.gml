/// @desc
if (!is_enabled)
	exit;

if (cooldown <= 0)
{
	if (current_sector == home_sector)
	{
		garble_sound_target = garble_sound_list[irandom(array_size(garble_sound_list) - 1)];
		
		//special cases for some garble sounds
		//usually the short ones that id prefer play in full
		switch (garble_sound_target)
		{
			case sfx_ekkathink_followme:
				garble_length = audio_sound_length(garble_sound_target);
				break;
				
			default:
				var aud_length = audio_sound_length(garble_sound_target);
				//play at least 25% of the audio
				garble_length = random_range(aud_length * 0.25, aud_length);
				break;
		
		}
		
		cooldown = garble_length;
		
		var l_obj = obj_labyrinth_visuals;
		var sect_info = l_obj.map_info[?current_sector];

		if (ds_map_exists(sect_info, "connections"))
		{
			var connections = sect_info[?"connections"];
			
			//never enter the same sector twice
			do
			{
				current_sector = connections[|max(irandom(ds_list_size(connections) - 1), 0)];
			} until (current_sector != last_sector_entered)
			
			last_sector_entered = current_sector;
			
			sect_info = l_obj.map_info[?current_sector];
			parent_sector = sect_info[?"parent"];
		
		}
		
	} else {
		cooldown = random(cooldown_in_time);
		current_sector = home_sector;
		garble_sound_target = -1;
		
	}
	
}
