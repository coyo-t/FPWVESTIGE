#region functions
function cctv_viewing () begin
	var cctv = obj_cctv;
	var par = parent_sector == cctv.cctv_current_sector_id.sector_name;

	return par && cctv.is_cctv_on;
	
end


function post_create () begin
	if (!init)
	{
		init = true;
		var cyc_inf = obj_cycle_manager.current_cycle_info;
		var lvl = cyc_inf[?"char_levels"];

		if (ds_map_exists(lvl, char_name))
		{
			aggro_level = lvl[?char_name];
		} else {
			aggro_level = 0;
			is_enabled = false;
		}
	
	}

end


function make_allowed (arr) begin
	var len = array_size(arr);
	var i = 0;
	var out = ds_map_create();

	repeat (len)
	{
		var key = arr[i++];
		out[?key] = true;
	}

	return out;

end


function draw_char_ico () begin
	var col = is_enabled ? c_white : c_red;
		
	var dx = 0;
	var dy = 0;
	with (class_cctv_map_cell)
	{
		var par = other.parent_sector;
		
		if ((par != -1 && sector_name == par) || (par == -1 && sector_name == other.current_sector))
		{
			dx = bbox_left + ((bbox_right - bbox_left) * 0.5);
			dy = bbox_top + ((bbox_bottom - bbox_top) * 0.5);
		
		}
		
	}

	draw_sprite_ext(
		sprite_index, 0, 
		dx - (sprite_width*.5), 
		dy - (sprite_height*.5),
		1, 1, 0,
		col,
		0.5
	);

end


#endregion

var l_obj = obj_labyrinth_visuals;

is_enabled = true;

init = false;

current_sector = starting_sector;
last_sector    = starting_sector;
target_sector  = starting_sector;
moved = false;

move_fuckyou = 128;
move_nofuck = false;
move_override_again_fuck = false;

var sect_info = l_obj.map_info[?current_sector];
parent_sector = sect_info[?"parent"] == -1 ? current_sector : sect_info[?"parent"];

cooldown_time = 0.5;
cooldown = 2.;
cooldown_delta = -1.;

cooldown_delta_damp = [0., 0., 0., 1.]; //[0., .25, .5, .75, 1.];
cooldown_delta_damp_ind = 0;
cooldown_delta_damp_cd_max = 2.;
cooldown_delta_damp_cd = cooldown_delta_damp_cd_max;

ads_move_flag = true;

is_cctv_viewing = false;

aggro_level = 0;

allowed_rooms = -1;

if (DEBUG)
{
	if (object_index != obj_chara_overnight)
	{
		aggro_level = irandom(AI_MAX_LEVEL)
	
	}
}
