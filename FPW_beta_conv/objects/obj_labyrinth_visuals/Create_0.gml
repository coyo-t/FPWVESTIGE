#region functions
function change_state(_state) begin
	if (state_alterable)
		state = _state;

end


function reset_camera_shit () begin
	camera_set_view_mat(camera_perspective, LOOKFORWARDS);
	camera_apply(view_camera[view_current]);

end

#endregion
//game_set_speed(5, gamespeed_fps)

//var count = sprite_get_number(sprite_index);
room_width  = sprite_width;// * count;
room_height = sprite_height;

enum room_states {
	lizz,
	cctv,
	cctv_anim,
	grun_kill,
	power_out
}

state = room_states.lizz;
state_alterable = true;

//infooo
map_info = info_load_json("labyrinth_map.json");

//run through all the sectors and replace draw routines with their script indicies
//mainly just to save headache later.
var ipairs = ds_map_find_first(map_info);
for (var i = 0; i < ds_map_size(map_info); ++i)
{
	var sect = map_info[? ipairs];
	ipairs = ds_map_find_next(map_info, ipairs);
	
	if (!ds_map_exists(sect, "draw_routine")) then continue else
	{
		sect[? "draw_routine"] = map_check_script(sect, "draw_routine") 
			? asset_get_index(sect[? "draw_routine"])
			: -1;
	}
	
}

sound_breathe = -1;

//debug? shit.
dbg_pano_enable = true;
d_points = ds_list_create();
//d_nemmi_testtext = buffer_load("C:/Users/Chymic/Desktop/lupine.buff");
