/// @desc input grabbing
input[?"mb_left_down"] = mouse_check_button_pressed(mb_left);
input[?"mb_left_held"] = mouse_check_button(mb_left);
input[?"mb_left_up"]   = mouse_check_button_released(mb_left);

input[?"mb_right_down"] = mouse_check_button_pressed(mb_right);
input[?"mb_right_held"] = mouse_check_button(mb_right);
input[?"mb_right_up"]   = mouse_check_button_released(mb_right);

input[?"mouse_x"]      = mouse_x_real();
input[?"mouse_y"]      = mouse_y_real();
//input[?"mouse_x_room"] = mouse_x_real_offset();
//input[?"mouse_y_room"] = mouse_y_real_offset();

input[?"mwheel_up"]   = mouse_wheel_up();
input[?"mwheel_down"] = mouse_wheel_down();

input[?"move_left"]  = keyboard_check(ord("A")) || keyboard_check(vk_left);
input[?"move_right"] = keyboard_check(ord("D")) || keyboard_check(vk_right);
input[?"move_up"]    = keyboard_check(ord("W")) || keyboard_check(vk_up);
input[?"move_down"]  = keyboard_check(ord("S")) || keyboard_check(vk_down);

input[?"ctrl_down"] = keyboard_check_pressed(vk_control);
input[?"space_down"] = keyboard_check_pressed(vk_space);
input[?"screenshot"] = keyboard_check_pressed(vk_f12);

input[?"pause"] = keyboard_check_pressed(ord("P"));
