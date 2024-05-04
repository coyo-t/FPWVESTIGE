function __init ()
{
	return instance_create_depth(0, 0, 0, meta_master);
}

function __on_game_begin ()
{
	room_goto(room_main_night_fps);
	//room_goto(room_main_night);
	//room_goto(room_480test);
}
