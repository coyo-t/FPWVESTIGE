/// @desc
//on_enter, on_exit, on_enter_attempt, on_exit_attempt, on_enter_deny, on_exit_deny

if (!is_enabled)
	exit;

//not gonna lie, i dont like that this is in end step.
//its just an unfortunate byproduct of the way i set up the initial systems
//of the game (the CCTV and room shit)
//rip
if (aggro_level > 0)
{
	var l_obj = obj_labyrinth_visuals.map_info;
	var reset = false;

	if ((target_sector != current_sector || move_blink) && ads_move_flag)
	{
		var exit_attempt  = true;
		var enter_attempt = true;
		
		var current_sector_info = l_obj[?current_sector];
		var target_sector_info  = l_obj[?target_sector];
	
		var roll = random((AI_MAX_LEVEL * 1.45) + 1) <= aggro_level;
		if (!move_nofuck)
			roll &= irandom(255) >= move_fuckyou; // fuck you i still dont feel like moving lol
		
		roll |= move_blink;
		
		if (trigger_events)
		{
			if (map_check_script(current_sector_info, "on_exit_attempt")) then
				exit_attempt = script_execute(asset_get_index(current_sector_info[?"on_exit_attempt"]));

			if (map_check_script(target_sector_info, "on_enter_attempt")) then
				enter_attempt = script_execute(asset_get_index(target_sector_info[?"on_enter_attempt"]));
		}
		
		if (roll && enter_attempt && exit_attempt)
		{
			current_sector = move_blink ? current_sector : target_sector;
			var last_parent = parent_sector;
			parent_sector = target_sector_info[?"parent"] == -1 ? current_sector : target_sector_info[?"parent"];
			moved = true;
		
			if (trigger_events)
			{
				if (map_check_script(target_sector_info, "on_enter")) then
					script_execute(asset_get_index(target_sector_info[?"on_enter"]));
		
				if (map_check_script(current_sector_info, "on_exit")) then
					script_execute(asset_get_index(current_sector_info[?"on_exit"]));
			
				
				var cctv_sect = obj_cctv.cctv_current_sector_id.sector_name;
				
				var flashkey = "dont_cause_move_flash";
				var can_flash = !ds_map_exists(current_sector_info, flashkey) && !ds_map_exists(target_sector_info, flashkey);
				var viewings = cctv_sect == parent_sector || (cctv_sect == last_parent && cctv_sect != parent_sector);
				
				if (viewings && can_flash)
				{
					obj_cctv.cctv_static_intensity = 300;
					obj_cctv.cctv_cam_switch_timer = sprite_get_number(spr_cctv_switch) - 1;
				}
				
			}
		
		} else {
			reset = true;
		
			if (trigger_events)
			{
				if (map_check_script(target_sector_info, "on_enter_deny") && !enter_attempt) then
					script_execute(asset_get_index(target_sector_info[?"on_enter_deny"]));
		
				if (map_check_script(current_sector_info, "on_exit_deny") && !exit_attempt) then
					script_execute(asset_get_index(current_sector_info[?"on_exit_deny"]));
			}
		}
	
	} else {
		reset = true;
	}

	if (reset && !move_override_again_fuck)
	{
		target_sector = current_sector;
	}

	last_sector = current_sector;

	// making the characters not move/move slower when the cctv anim is playing
	cooldown_delta_damp_ind -= (cooldown_delta_damp_cd <= 0);
	cooldown_delta_damp_ind = clamp(cooldown_delta_damp_ind, 0, array_size(cooldown_delta_damp) - 1);
	
	var is_cctv = obj_cctv.is_anim_playing;
	var damp = is_cctv ? cooldown_delta_damp[floor(cooldown_delta_damp_ind)] : 1.;
	
	cooldown += ((dt() * damp) * cooldown_delta);
	
	cooldown_delta_damp_ind += (obj_cctv.state_changed);
	cooldown_delta_damp_ind = clamp(cooldown_delta_damp_ind, 0, array_size(cooldown_delta_damp) - 1);
	
	cooldown_delta_damp_cd = (cooldown_delta_damp_cd <= 0) 
		? cooldown_delta_damp_cd_max 
		: cooldown_delta_damp_cd - (dt() * !is_cctv);
	

	parent_sector = (l_obj[?current_sector][?"parent"] == -1) 
		? current_sector 
		: l_obj[?current_sector][?"parent"];
}
