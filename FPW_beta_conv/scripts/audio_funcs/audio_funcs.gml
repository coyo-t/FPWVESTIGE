///@arg soundid
function audio_pause_0vol(sndid) begin
	if (audio_sound_get_gain(sndid) == 0)
	{
		audio_pause_sound(sndid);
	} else {
		audio_resume_sound(sndid);
	}

end


///@arg array
function audio_stop_multi(snds) begin
	var i = 0;
	var size = array_size(snds);
	repeat (size)
	{
		var snd = snds[i++];
		if (audio_is_playing(snd))
		{
			audio_stop_sound(snd);
		}
	}

end
