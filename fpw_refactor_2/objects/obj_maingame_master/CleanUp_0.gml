free_all_entities();
input.free();
delete input;
delete timer;
delete mats;
delete world;
delete view;
delete proj;

var k = variable_struct_get_names(views);
for (var i = 0, l = array_length(k); i < l; i++)
{
	var _v = views[$k[i]];
	instance_destroy(_v, false);
}

set_mouse_grab(false);
