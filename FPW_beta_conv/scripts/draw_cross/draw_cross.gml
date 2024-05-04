///@arg x
///@arg y
///@arg size
function draw_cross(argument0, argument1, argument2) {

	var _size = argument2 * 0.5;

	draw_line(
		argument0 - _size,
		argument1 - _size,
		argument0 + _size,
		argument1 + _size
	);

	draw_line(
		argument0 + _size,
		argument1 - _size,
		argument0 - _size,
		argument1 + _size
	);




}
