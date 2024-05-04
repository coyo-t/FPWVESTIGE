/// @desc
var obx = 0;
var oby = 0;

if (instance_exists(follow_object))
{
	x = follow_object.x;
	y = follow_object.y;
}

var px = x + offset_x + obx;
var py = y + offset_y + oby;

camera_set_view_pos(view_cam, floor(px + 0.5), floor(py + 0.5));

audio_listener_position(
	px + (camera_get_view_width(view_cam)  * 0.5),
	py + (camera_get_view_height(view_cam) * 0.5),
	0
);
