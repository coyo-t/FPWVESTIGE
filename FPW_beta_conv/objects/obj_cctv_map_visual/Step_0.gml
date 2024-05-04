/// @desc
if (obj_cctv.is_cctv_on)
{
	var sect_id = obj_cctv.cctv_current_sector_id;
	if (object_get_parent(sect_id.object_index) == class_cctv_map_cell_cube)
	{
		var spd = sect_id.look_speed;
	
		sect_id.camera_yaw   += (meta_master.get_inp("move_right") - meta_master.get_inp("move_left")) * dt() * spd;
		sect_id.camera_pitch += (meta_master.get_inp("move_up") - meta_master.get_inp("move_down")) * dt() * spd;
	}
	
}
