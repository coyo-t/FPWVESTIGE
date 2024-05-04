/// @desc
if (is_enabled && !obj_cctv.is_cctv_active) {
	mouse_down = meta_master.get_inp("mb_left_held");
	var pos = obj_panorama_labyrinth.dist_pos();
	
	var mouse_inbounds = point_in_bbox(
		pos[0],
		pos[1]
	);
	
	if ((!last_mouse && !is_on) || (is_on)) {
		var parn = parent_door != noone ? parent_door.anim_frame == -1 : true;
		is_on = mouse_down && mouse_inbounds && parn && !obj_cctv.was_cctv_on;
		
	} else {
		is_on = false;
	}
	
} else {
	is_on = false;
	mouse_down = false;
}

obj_power.affect_drain(is_on ? 1 : 0);

if (irandom(512) < 2 && is_on) {
	flicker_queue = true;
}
