image_blend = is_cctv_on ? c_white : $00ADDE;
draw_sprite_ext(sprite_index, is_cctv_on, x, y, 1, 1, 0, image_blend, .5);
