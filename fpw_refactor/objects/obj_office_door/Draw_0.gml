var s_info = states[state];

if (curr_frame > -1 && curr_frame <= s_info.anim_count)
{
	draw_sprite(s_info.anim, curr_frame, 0, 0);
}

hitbox.draw();

//draw_text(x, y, tostr(curr_frame) + "\n"+(is_fully_closed ? "TRUE":"FALSE"));
