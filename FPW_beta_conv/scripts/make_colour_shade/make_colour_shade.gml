///@arg shade
function make_colour_shade(argument0) {
	var shade = argument0 & $FF;

	return shade << 16 | shade << 8 | shade;



}
