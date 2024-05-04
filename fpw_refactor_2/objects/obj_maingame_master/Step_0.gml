if (keyboard_check_pressed(vk_escape))
{
	game_end();
}

input.update_all();

if (grab_mouse)
{
	update_mouse_grab();
	turn_player();
}

if (timer.update(self))
{
	input.flush_all();
}

