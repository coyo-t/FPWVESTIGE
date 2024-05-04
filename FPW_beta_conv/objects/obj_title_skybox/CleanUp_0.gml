/// @desc

for (var i = 0; i < array_size(sky_mdl); i++)
{
	vertex_delete_buffer(sky_mdl[i]);
}

camera_destroy(sky_cam);
