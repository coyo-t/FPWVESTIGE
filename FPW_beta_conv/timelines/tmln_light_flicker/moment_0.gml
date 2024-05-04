alpha_active = false;
image_alpha = 0;
var s = audio_play_sound(sfx_spark, 2, false);
audio_sound_gain(s, 0.3, 0);
audio_sound_pitch(s, random_range(2, 4));
