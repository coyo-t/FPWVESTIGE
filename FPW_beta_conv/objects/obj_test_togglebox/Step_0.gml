/// @desc
var mx = meta_master.get_inp("mouse_x");
var my = meta_master.get_inp("mouse_y");
var o = obj_perspcorrecttest;
var dp = point_trans(mx, my, o.point_trans_buff, RESW, RESH);

state ^= point_in_bbox(dp[0], dp[1]) && mouse_check_button_pressed(mb_left);

image_blend = state ? c_green : c_white;
image_alpha = 0.25;
