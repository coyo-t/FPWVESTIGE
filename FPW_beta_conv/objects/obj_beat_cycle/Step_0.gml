/// @desc
if (timer >= time_to_return)
{
	//todo, make it so you decide whether you want to go back to menu or continue
	room_goto(room_labyrinth_office);
}

timer += dt();

//camera_set_view_angle(view_camera[0], (timer / time_to_return) * 360);
