function __init ()
{
	return instance_create_depth(0, 0, 0, obj_meta_master);
}

function __on_game_begin ()
{
	room_goto(room_maingame);
}
