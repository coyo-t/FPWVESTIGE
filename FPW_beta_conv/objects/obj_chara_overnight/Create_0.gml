/// @desc

// Inherit the parent event
event_inherited();

home_sector = "overnight";
last_sector_entered = -1;

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

garble_length = 0;
garble_sound_target = -1;
garble_pitch_variation = 0.1;
garble_volume = 0.9;
garble_sound_id = -1;
var __garble_sound_list = [
	sfx_ekkathink_suiyubi, 9,
	
	sfx_ekkathink_aftertouch_wrong, 4,
	
	sfx_ekkathink_scream, 3,
	
	sfx_ekkathink_banshee, 2,
	
	//sfx_ekkathink_spritetalk2, 1,
	
	//sfx_ekkathink_eas, 2,
	
	sfx_ekkathink_mudiats, 3,
	
	sfx_ekkathink_followme, 3,
	
	//sfx_ekkathink_long, 1
];

garble_sound_list = [];

{
	var arr = __garble_sound_list;
	var size = array_size(arr);
	for (var i = 0; i < size; i += 2)
	{
		var ind = arr[i];
		var amn = arr[i+1];
		repeat (amn)
		{
			array_push(garble_sound_list, ind);
		}
	}
}
