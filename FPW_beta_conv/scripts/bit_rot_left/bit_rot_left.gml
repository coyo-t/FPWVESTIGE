///@arg n
///@arg d
function bit_rot_left(argument0, argument1) {
	var n = argument0;
	var d = argument1;

	return ((n << d)|(n >> (8 - d))) & $FF;



}
