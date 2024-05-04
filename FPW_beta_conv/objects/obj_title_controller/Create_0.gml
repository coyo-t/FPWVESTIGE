menustates = ds_map_create();
curr_state = -1;
_curr = -1;

bg_obj = obj_title_skybox;

///@arg bg_pitch
///@arg bg_yaw
///@arg bg_roll
///@arg cell_x
///@arg cell_y
///@arg draw_skybox
function menu_state (ap, ay, ar, cx, cy, dsky, fov) constructor begin
	bkd_pitch = ap;
	bkd_yaw   = ay;
	bkd_roll  = ar;

	cell_x = cx;
	cell_y = cy;

	do_draw_skybox = dsky;

	bkd_fov = fov_h2v(fov, RESW, RESH)

end

///@desc returns whether the state was changed
function change_state (_targ) begin
	if ((_curr == -1) || (ds_map_exists(menustates, _targ) && _targ != _curr))
	{
		curr_state = menustates[?_targ];
		_curr = _targ;
		return true;
	}
	
	return false;

end

function current_state_name () begin
	return _curr;
end

function force_current_posangle () begin
	bg_obj.sky_pitch = curr_state.bkd_pitch;
	bg_obj.sky_yaw   = curr_state.bkd_yaw;
	bg_obj.sky_roll  = curr_state.bkd_roll;

	bg_xpos  = curr_state.cell_x;
	bg_ypos  = curr_state.cell_y;
	
	bg_obj.sky_fov  = curr_state.bkd_fov;
	
	bg_obj.update_camera(curr_state);
	
end


