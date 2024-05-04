///@arg sprite
///@arg frame
///@arg delta
function animate_and_return(argument0, argument1, argument2) {

	var frame = argument1;

	var frameSpeed = sprite_get_speed(argument0) * argument2;

	return frame + (dt() * frameSpeed);



}
