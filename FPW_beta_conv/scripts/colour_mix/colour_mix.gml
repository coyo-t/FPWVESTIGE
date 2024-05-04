///@arg col_1
///@arg col_2
///@arg fac
function colour_mix(argument0, argument1, argument2) {

	return make_colour_rgb(
		lerp(colour_get_red(argument0), colour_get_red(argument1), argument2),
		lerp(colour_get_green(argument0), colour_get_green(argument1), argument2),
		lerp(colour_get_blue(argument0), colour_get_blue(argument1), argument2)
	);



}
