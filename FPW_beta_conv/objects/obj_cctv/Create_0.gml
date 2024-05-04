#region functions
function play_flip_sound () begin
	if (was_cctv_active != is_cctv_active)
	{
		if (audio_is_playing(cctv_flip_sound)) then audio_stop_sound(cctv_flip_sound);
	
		cctv_flip_sound = audio_play_sound(
			!is_cctv_on ? sfx_cam_up : sfx_cam_down,
			10, false
		);
		audio_sound_pitch(cctv_flip_sound, 1 + random_range(-0.1, 0.1));
	
	}

end


function set_active (state) begin
	is_cctv_active = state;
	mouse_still_over = true;
	is_anim_playing = true;
	play_flip_sound();

end


#endregion

is_enabled = true;

was_mouse_over   = false;
mouse_still_over = false;

is_anim_playing = false;
is_cctv_active  = false; //if its been toggled on but the screens not up
was_cctv_active = false;
is_cctv_on      = false; //if the screen is up and on
was_cctv_on     = false;

state_changed   = false;

cctv_anim_frame = -1;
cctv_anim = spr_cam_flip;
cctv_anim_count = sprite_get_number(cctv_anim);
cctv_flip_sound = -1;

cctv_static_target_intensity = 32;//c_dkgrey & $0000FF;
cctv_static_intensity = cctv_static_target_intensity;
cctv_static_intensity_delta = 400;

cctv_static_sound_asset = sfx_cctv_static;
cctv_static_sound = audio_play_sound(cctv_static_sound_asset, 10, true);
cctv_static_volume = 0.31;
cctv_static_volume_multi = 0.34;
cctv_static_pitch = 1.4;
cctv_static_pos = 0;
audio_pause_sound(cctv_static_sound);

cctv_cam_garble_timer = 0.;
cctv_cam_switch_timer = 0.;

colour_active   = $caec22;
colour_inactive = $15c3f8;

cctv_current_sector_id = -1;

toggled = false;

var ss = spr_cctv_ico_cctv;
var so = empty_cctv_button_pos_on;
cctv_button_on_rect = [
	so.x,
	so.y,
	so.x + (sprite_get_bbox_right(ss) - sprite_get_bbox_left(ss)),
	so.y + (sprite_get_bbox_top(ss) - sprite_get_bbox_bottom(ss)),
	ss
];

cctv_button_off_rect = [
	bbox_left,
	bbox_top,
	bbox_right,
	bbox_bottom,
	sprite_index
];

cctv_button_to_use = cctv_button_off_rect;
