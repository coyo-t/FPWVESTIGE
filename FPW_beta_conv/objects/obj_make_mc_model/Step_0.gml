/// @desc

var lcur = current;
var mwheel = mouse_wheel_up() - mouse_wheel_down();
current = clamp(current - mwheel, 0, array_size(textures) - 1);

if ((current != lcur && !ds_map_exists(meshes, tex_names[current])) || !start)
{
	meshes[?tex_names[current]] = minecraft_create_mesh(textures[current]);
	
}

start = true;
