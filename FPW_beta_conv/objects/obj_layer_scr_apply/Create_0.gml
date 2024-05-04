/// @desc remember, begin is the lower of the two

layer_begin = layer_get_id(layer_begin);
layer_end   = layer_get_id(layer_end);

var layers_exist = (layer_begin != -1 && layer_end != -1);
var scripts_exist = (
	(scr_begin != -1 && scr_begin != noone) &&
	(scr_end != -1 && scr_end != noone)
);

if (layers_exist && scripts_exist)
{
	layer_script_begin(layer_begin, scr_begin);
	layer_script_end(layer_end, scr_end);
}

instance_destroy();
