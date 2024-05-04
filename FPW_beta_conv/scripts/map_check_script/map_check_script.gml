///@arg ds_map
///@arg key
function map_check_script(argument0, argument1) {
	var dsmap = argument0;
	var key = argument1;

	var scriptName = ds_map_exists(dsmap, key) ? dsmap[? key] : -1;

	return script_exists(asset_get_index(!is_undefined(scriptName) ? scriptName : -1));



}
