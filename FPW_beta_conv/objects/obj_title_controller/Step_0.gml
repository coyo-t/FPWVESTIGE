/// @desc
var cam = view_camera[0];
var cstate = curr_state;
var lerpspd = 0.001;

if (keyboard_check(vk_shift))
{
	var op = cstate.bkd_pitch;
	var oy = cstate.bkd_yaw;
	
	var mx = mouse_x_real();
	var my = mouse_y_real();
	
	cstate.bkd_pitch = t2m1(my / room_height) * 90;
	cstate.bkd_yaw   = (mx / room_width) * 360;
	
	bg_obj.update_camera(cstate);
	
	cstate.bkd_pitch = op;
	cstate.bkd_yaw   = oy;
	
}
else
{
	bg_obj.update_camera(cstate);
}


//if (cstate.do_draw_skybox)
//{
//	bg_yaw   = lerp_dt(bg_yaw, cstate.bkd_yaw, lerpspd);
//	bg_pitch = lerp_dt(bg_pitch, cstate.bkd_pitch, lerpspd / 2);
//	bg_roll  = lerp_dt(bg_roll, cstate.bkd_roll, lerpspd);

//	matrix_stack_push(matrix_build(
//		0,0,0, 
	
//		0,0, bg_roll + (sin(time() / 2) * 2), 
	
//		1,1,1
//	));

//	matrix_stack_push(matrix_build(
//		0,0,0, 
	
//		bg_pitch,
//		bg_yaw, 
//		0, 
	
//		1,1,1
//	));

//	bg_obj.sky_viewmat = matrix_stack_top();

//	matrix_stack_pop();
//	matrix_stack_pop();
	
//	bg_obj.sky_fov = lerp_dt(bg_yaw, cstate.bkd_yaw, lerpspd);
	
//}

bg_xpos = lerp_dt(bg_xpos, cstate.cell_x, lerpspd);
bg_ypos = lerp_dt(bg_ypos, cstate.cell_y, lerpspd);

camera_set_view_pos(cam, bg_xpos * room_width, bg_ypos * room_height);

if (keyboard_check_pressed(vk_backspace))
	game_restart();
