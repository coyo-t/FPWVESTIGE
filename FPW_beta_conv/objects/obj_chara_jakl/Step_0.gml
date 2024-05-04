/// @desc
debug_push_string("rennt", is_running);
debug_push_string("time", running_timer);
debug_push_string("cd", running_cooldown);
debug_push_string("curr", current_sector);
debug_push_string("last", last_sector);
debug_push_string("targ", target_sector);
debug_push_string("enab", is_enabled);

if (!is_enabled)
	exit;

var watched = cctv_viewing();

if (hit_player)
{
	//i feel like moving to the player now
	move_blink = true;
	ads_move_flag = true;

	move_override_again_fuck = true;
	is_running = false;
	running_cooldown = running_cooldown_max;
	target_sector  = "player";
	move_nofuck = true;
	hit_player = false;
}

if (is_running)
{
	if (running_timer <= running_sector.ads_time)
	{
		move_blink = true;
		move_override_again_fuck = true;
		current_sector = running_sector.ret_sect;
		target_sector  = running_sector.ret_sect;
		last_sector    = running_sector.ret_sect;
		hit_player = true;
	}
	
	if (!has_been_seen && watched)
	{
		has_been_seen = true;
		running_timer = running_sector.spr_time;
	
	}
	
	running_timer -= dt();
	
} else {
	running_cooldown -= dt() * (watched ? running_cooldown_retard : 1);
	
	if (running_cooldown <= 0 && ds_map_exists(running_anims, current_sector))
	{
		var run_chance = irandom($FF) < $F0;
		if (run_chance && !watched)
		{
			running_cooldown = running_cooldown_max;
			is_running = true;
			running_sector = running_anims[? current_sector];
		
			running_timer = running_sector.spr_time * running_unseen_multi;
			has_been_seen = false;
		} else {
			running_cooldown = running_cooldown_min;
		
		}
	}
	
	if (!hit_player && !is_running)
	{
		event_inherited();
	}
	
}

//if (keyboard_check_pressed(ord("F")))
//{
//	move_blink = true;
//	current_sector = "airlock_l";
//	target_sector  = "airlock_l";
//	alarm[0] = 1;
//}
