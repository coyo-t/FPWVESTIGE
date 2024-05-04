//TODO: separate into a door controller button and this (the door itself)
enum OfficeDoorStates {
	open,
	closed,
};

state = -1;

is_enabled = true;

is_fully_closed = false;
closed_threshold = 0.55;

curr_frame = -1;
cmax = -1;

click_sound = -1;
door_sound = -1;

hitbox = (new AABB_2d()).from_instance_bbox();

function set_current_anim (_spr)
{
	curr_frame = curr_frame / curr_anim_count;
	
	curr_anim = _spr;
	curr_anim_count = sprite_get_number(curr_anim) - 1;
	
	curr_frame = curr_anim_count * (1 - curr_frame);
	
}

function StateInfo (_anim, _cmax, _sfx) constructor begin
	anim = _anim;
	anim_count = sprite_get_number(_anim) - 1
	cmax = anim_count + _cmax;
	
	door_sound = _sfx;
	
end


states = [];
states[OfficeDoorStates.open] = new StateInfo(anim_open, 1, sfx_door_open);
states[OfficeDoorStates.closed] = new StateInfo(anim_close, 0, sfx_door_close);

///@func set_state(state, *play_sound)
///@arg {OfficeDoorStates} state
///@arg {bool} *play_sound
function set_state (_state, _play_sound)
{
	if (_state != state)
	{
		state = _state;
		set_current_anim(states[state].anim);
		
		if (_play_sound == undefined || _play_sound)
		{
			if (audio_is_playing(door_sound)) audio_stop_sound(door_sound);
	
			door_sound = audio_play_sound_at(
				states[state].door_sound,
				x, y, 0,
				1, 100, 1,
				false, 10
			);
	
			audio_sound_gain(door_sound, 0.7/2, 0);
	
			if (audio_is_playing(click_sound)) audio_stop_sound(click_sound);
		
			click_sound = audio_play_sound_at(
				sfx_doortwist,
				x, y, 0,
				1, 100, 1,
				false, 10
			);
	
			audio_sound_gain(click_sound, .325, 0);
			audio_sound_pitch(click_sound, .9 + random_range(-.05, .05));
			
		}
		
	}
	
}

curr_anim = -1;
last_anim = -1;
curr_anim_count = -1;

set_state(OfficeDoorStates.open, false);

curr_frame = curr_anim_count + 1;

function set_enable (is)
{
	is_enabled = is;
	set_state(OfficeDoorStates.open);
}
