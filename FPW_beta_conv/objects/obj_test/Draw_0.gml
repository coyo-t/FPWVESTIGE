/// @desc
image_xscale = (mouse_x_real() - x) / (room_width + sprite_width);
image_yscale = (mouse_y_real() - y) / (room_height + sprite_height);

draw_push_state();
draw_self();

draw_set_colour(c_yellow);

draw_push_state();
draw_set_halign(fa_left);
draw_set_valign(fa_bottom);
draw_text(bbox_left, bbox_top, string(bbox_left) + "\n" + string(bbox_top));
draw_pop_state();

draw_push_state();
draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_text(bbox_right, bbox_bottom, string(bbox_right) + "\n" + string(bbox_bottom));
draw_pop_state();

draw_pop_state();
