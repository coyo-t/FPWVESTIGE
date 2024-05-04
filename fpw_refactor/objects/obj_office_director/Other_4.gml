fpw.resize_appsurf(view_wport[0], view_hport[0], true);

var courier = obj_player_info_courier;

if (instance_number(courier) > 0)
{
	obj_office_player.x = courier.x;
	instance_destroy(courier);
}
else
{
	obj_office_player.x = (room_width / 2) - (view_wport[0] / 2);
}
