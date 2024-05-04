/// @desc
#region functions
///@arg application_position
function scr_gui_reset (app_pos) begin
	display_set_gui_size(-1, -1);
	display_set_gui_maximise(
		(1/RESW)*(app_pos[2]-app_pos[0]),
		(1/RESH)*(app_pos[3]-app_pos[1]),
		app_pos[0],
		app_pos[1]
	);
	
end


///@arg key
function get_inp (key) begin
	key = string(key);

	if (key == "mouse_x_room")
		return mouse_x_real_offset();
	if (key == "mouse_y_room")
		return mouse_y_real_offset();

	if (ds_map_exists(input, key))
		return input[? key];
	else
		return false;

end

///@arg winw
///@arg winh
///@arg guiw
///@arg guih
///@arg apos
function draw_screen (winw, winh, guiw, guih, apos) begin
	gpu_push_state();
	gpu_set_texfilter(true);
	//gpu_set_colourwriteenable(true, true, true, false);
	gpu_set_alphatestenable(false);

	//draw the fuzzy background
	if (apos[2] != guiw || apos[3] != guih)
	{
		display_set_gui_size(winw, winh);
		display_set_gui_maximise(1, 1, 0, 0);

		shader_set(sha_rBlur);
		shader_send("amount", 0.1);
		draw_surface_stretched_ext(
			application_surface,
			0, 0,
			apos[2] + apos[0], apos[3] + apos[1],
			c_dkgrey, 1.
		);
		shader_reset();
	
		scr_gui_reset(apos);

		draw_push_state();
		draw_set_colour(c_black);
		draw_rectangle(
			0, 0, 
			surface_get_width(application_surface), surface_get_height(application_surface),
			true
		);
		draw_pop_state();

	}

	//draw the screen
	draw_surface(application_surface, 0, 0);

	gpu_pop_state();

end


function last_frame () begin
	if (sprite_exists(prev_frame)) sprite_delete(prev_frame);

	prev_frame = sprite_create_from_surface(
		application_surface, 
		0, 0,
		surface_get_width(application_surface),
		surface_get_height(application_surface),
		false,
		false,
		0, 0
	);

end


#region save data funcs

//savedata macros
#macro SAVE_NAME             "parallel.sav"
#macro SAVEKEY_CYCLE         "current_cycle"
#macro SAVEKEY_EXIT_TIME     "cycle_exit_time"
#macro SAVEKEY_EXIT_TIME_NRM "cycle_exit_time_normal"
#macro SAVEKEY_DIED_TO       "who_killed_last"
#macro SAVEKEY_BEAT_GAME     "has_beat_game"
#macro SAVEKEY_BEAT_PSYCHE   "has_beat_psyche"

#macro CONF_NAME             "conf"
#macro CONFKEY_VOLUME        "volume"

///@arg clear
function plrdat_clear () begin
	if (ds_exists(save_data, ds_type_map)) ds_map_destroy(save_data);
	save_data = ds_map_create();
	var conf = ds_map_create();
	
	save_data[?SAVEKEY_CYCLE]         = "maceroni";
	save_data[?SAVEKEY_DIED_TO]       = -1;
	save_data[?SAVEKEY_BEAT_GAME]     = false;
	save_data[?SAVEKEY_BEAT_PSYCHE]   = false;
	save_data[?SAVEKEY_EXIT_TIME]     = 0.;
	save_data[?SAVEKEY_EXIT_TIME_NRM] = 0.;
	
	conf[?CONFKEY_VOLUME] = 0.35;
	
	ds_map_add_map(save_data, CONF_NAME, conf);

end


function plrdat_load () begin
	var path = temp_directory + SAVE_NAME;
	var f = string_cc_load(path);

	if (f != -1)
	{
		save_data = json_decode(base64_decode(f));
	}
	else
	{
		plrdat_clear();
		plrdat_save();
	}

end


///@arg clear
function plrdat_save () begin
	var clear = argument_count == 1 ? argument[0] : false;
	var path = temp_directory + SAVE_NAME;
	
	if (clear)
		plrdat_clear();
	
	var savestr = base64_encode(json_encode(save_data));
	
	string_cc_save(savestr, path);
	

end


#endregion

#endregion

enum meta_master_alarms {
	get_first_frame = 0,
	pause_room_unpersist = 1
}

event_inherited();
gpu_set_zwriteenable(true);
gpu_set_ztestenable(true);
//gpu_set_alphatestenable(true);
application_surface_draw_enable(false);

prev_frame = -1;
screenshot_surface = -1;
gui_draw_to_appsurface = true;

alarm[meta_master_alarms.get_first_frame] = 2;

draw_set_model_colour(c_white);
draw_set_model_alpha(1.);

display_vsync = false;
display_antialias = 0;

display_reset(display_antialias, display_vsync);

input = ds_map_create();
input_last = ds_map_create();

//save data
//working_directory
save_data = -1;
plrdat_load();

conf_data = save_data[?CONF_NAME];
audio_master_gain(conf_data[?CONFKEY_VOLUME]);

//pause_room = -1;
//pause_room_was_pers = false;
//pause_gpu_state = -1;
