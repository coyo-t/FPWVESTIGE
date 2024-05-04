/// @desc
is_mouse_over = false;
if (!cctv_object.is_cctv_on) { exit; }

var mx = meta_master.get_inp("mouse_x");
var my = meta_master.get_inp("mouse_y");

var click = meta_master.get_inp("mb_left_down");
is_mouse_over = collision_point(
		mx, my, class_cctv_map_cell,
		bounds_fine, false
	) == id;
/*
var col_rough = point_in_bbox(mx, my);
var col_fine = true;
	
is_mouse_over = col_rough;
	
if (bounds_fine && col_rough && click)
{
	col_fine = collision_point(
		mx, my, class_cctv_map_cell,
		true, false
	) == id;
		
	is_mouse_over = col_fine
		
}
*/
	
if (is_mouse_over && click && cctv_object.cctv_current_sector_id != id)
{
	class_cctv_map_cell.is_active = false;
	is_active = true;
	cctv_object.cctv_current_sector_id = id;
	cctv_object.cctv_cam_switch_timer = sprite_get_number(spr_cctv_switch) - 1;
	cctv_object.cctv_static_intensity = 255;
		
	if (audio_is_playing(sfx_cambase))
		audio_stop_sound(sfx_cambase);
	var s = audio_play_sound(sfx_cambase, 5, false);
	audio_sound_gain(s, blip_volume, 0);
		
}
	
