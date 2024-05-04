function AudioChannel (_priority) constructor begin
	__sfx = -1;
	__priority = _priority;
	paused = false;
	loops = false;
	
	static __stop_if_playing = function ()
	{
		gml_pragma("forceinline");
		if (audio_is_playing(__sfx))
		{
			audio_stop_sound(__sfx);
		}
	}
	
	///@func play_sound(sound_asset, gain)
	static play_sound = function (_sfx, _gain)
	{
		__stop_if_playing();
		
		__sfx = audio_play_sound(_sfx, __priority, loops);
		audio_sound_gain(__sfx, _gain, 0);
	}
	
	static set_sound_paused = function (_state)
	{
		paused = _state;
		
		if (_state)
		{
			audio_pause_sound(__sfx);
		}
		else
		{
			audio_resume_sound(__sfx);
		}
	}
end
