function __scr_on_move_airlock_generic (lb) begin
	if (char_name != "overnight" && lb.is_on) 
	{
		lb.flicker_queue = true;
		//inst_lightbutton_m.is_on = false;
	}
end


function scr_on_move_airlock_l () begin
	__scr_on_move_airlock_generic(inst_lightbutton_l);

end


function scr_on_move_airlock_r () begin
	__scr_on_move_airlock_generic(inst_lightbutton_r);

end


function scr_on_move_interro () begin
	__scr_on_move_airlock_generic(inst_lightbutton_m);

	if (char_name != "grun" && obj_chara_grun.current_sector == "interro")
	{
		obj_chara_grun.cooldown += 0.5;
	
	}

end


///@arg xpos
///@arg door
function scr_exit_atp_airlock_generic (argument0, argument1) begin

	var targ_plr = target_sector == "player";
	var door_closed = argument1.is_closed;

	if (targ_plr && door_closed)
	{
		var sfx_use = -1;
	
		switch (char_name)
		{
			case "cici":
				var scrt = [
					"droid_start",
					"interro",
					"medi_2"
				];
				scrt = array_rand(scrt);
				sfx_use = sfx_cici_enterdeny;
				target_sector  = scrt;
				current_sector = scrt;
				last_sector    = scrt;
				cooldown = cooldown_time * 2.5;
				move_override_again_fuck = true;
				move_nofuck = true;
			break;
			case "jakl":
				sfx_use = sfx_jakl_enterdeny;
				target_sector  = running_reset_sector;
				current_sector = running_reset_sector;
				last_sector    = running_reset_sector;
				cooldown = cooldown_time * 2.2;
				move_override_again_fuck = true;
				move_nofuck = true;
			break;
		}
	
		if (sfx_use != -1)
		{
			var s = audio_play_sound_at(sfx_use, argument0, 360, 10, 1, 100, 1, false, 10);
			audio_sound_gain(s, 0.75, 0.);
			audio_sound_pitch(s, 1+random_range(-0.075, 0.075));
		}

		return false;
	
	}

	return true;
	
end


function scr_exit_atp_airlock_l () begin
	return scr_exit_atp_airlock_generic(0, obj_door_l);

end


function scr_exit_atp_airlock_r () begin
	return scr_exit_atp_airlock_generic(2560, obj_door_r);

end


function scr_on_deny_test () begin
	var s = audio_play_sound(sfx_deny, 4, false);
	audio_sound_gain(s, 0.3, 0);

end


function scr_on_enter_test () begin
	//if (char_name == "grun" || char_name == "cici") then
	//	return true;
	//else
	//	return false;
	return true;
	//if (char_name == "grun") then
	//	return true;
	//else
	//	return !aggro_level == 11;

end


function scr_on_enter_player () begin
	is_enabled = false;
	//alarm[11] = 1;

	switch (char_name)
	{
		case "jakl":
			instance_destroy(obj_deadmeat);
		
			var dm = instance_create_depth(0, 0, inst_xscare_loc.depth, obj_deadmeat);
			dm.created_by = char_name;
			dm.scr_trigger = scr_trig_true;
			dm.anim = spr_xscare_jakl;
			dm.sound = sfx_xscream;
		break;
	
		case "cici":
			instance_destroy(obj_deadmeat);
		
			var dm = instance_create_depth(0, 0, inst_xscare_loc.depth, obj_deadmeat);
			dm.created_by = char_name;
			dm.scr_trigger = trigger_scr;
			dm.anim = spr_xscare_cici;
			dm.sound = sfx_xscream;
		break;
	
		case "grun":
			if (!obj_cctv.is_cctv_on)
			{
				obj_screen_decor.blacken = 1.;
			}
			obj_labyrinth_visuals.change_state(room_states.grun_kill);
			scr_lab_disable_room();
			//obj_calm_tv.disable();
			
			var dm = instance_create_depth(0, 0, inst_xscare_loc.depth, obj_deadmeat);
			dm.created_by = char_name;
			dm.scr_trigger = trigger_scr;
			dm.anim = spr_xscare_grun;
			dm.sound = sfx_xscream;
			
			var s = audio_play_sound(sfx_grun_breakin, 1, false);
			audio_sound_pitch(s, 0.97);
			audio_sound_gain(s, 0.8, 0);
		
			//obj_office_player.is_enabled = false;
			//obj_office_player.is_enabled_override = true;
		break;
	
	}

end

