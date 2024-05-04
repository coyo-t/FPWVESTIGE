/// @desc
var fcount = sprite_get_number(anim_current) - 1;

if (is_enabled && !obj_cctv.is_cctv_active)
{
	var check_click = meta_master.get_inp("mb_left_held");
	
	var pos = obj_panorama_labyrinth.dist_pos();
	
	var check_inbound = point_in_bbox(
		pos[0],
		pos[1]
	);

	is_on = check_click && check_inbound && anim_current != door_sprite_open;
	//is_on |= !(anim_frame <= -1 && anim_frame >= fcount);

} else {
	is_on = false;
}

was_fully_closed = (is_on != was_on) && (!is_on) && (anim_frame >= fcount);

if (was_fully_closed)
{
	anim_current = door_sprite_open;
	fcount = sprite_get_number(anim_current) - 1;
	anim_frame = fcount;
	
}

if (is_on != was_on)
{
	if (audio_is_playing(sound)) then audio_stop_sound(sound);
		
	sound = audio_play_sound_at(
		!is_on ? sfx_door_open : sfx_door_close,
		x, y, depth,
		1, 100, 1,
		false, 10
	);
	
	audio_sound_gain(sound, 0.7, 0);
	
	if (audio_is_playing(sound_twist)) then audio_stop_sound(sound_twist);
		
	sound_twist = audio_play_sound_at(
		sfx_doortwist,
		x, y, depth,
		1, 100, 1,
		false, 10
	);
	
	audio_sound_gain(sound_twist, .65, 0);
	audio_sound_pitch(sound_twist, .9 + random_range(-.05, .05));
	
}

anim_frame = animate_and_return(anim_current, anim_frame, is_on * 2 - 1);
anim_frame = clamp(anim_frame, -1, fcount);

is_closed = anim_frame >= fcount * .5;
obj_power.affect_drain(is_closed ? 1 : 0);

if (anim_frame <= -1)
{
	anim_current = door_sprite_close;
}
