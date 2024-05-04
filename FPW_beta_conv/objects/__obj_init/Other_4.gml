/// @desc
if (RANDOMIZE) { randomize(); }

if (room_exists(start_room))
{
	room_goto(start_room);
} else {
	visible = true;
}

/*
var ind = 0;
do
{
	var isMeta = object_get_parent(ind) == class_meta;
	if (isMeta)
	{
		instance_create_depth(0,0,0,ind);
	}
	
	ind++;
} until (!object_exists(ind))
*/
/// @desc
