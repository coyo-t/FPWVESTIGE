///@arg x
///@arg inp_min
///@arg inp_max
///@arg out_min
///@arg out_max
function map_range(argument0, argument1, argument2, argument3, argument4) {

	var input   = argument0;
	var inp_min = argument1;
	var inp_max = argument2;
	var out_min = argument3;
	var out_max = argument4;

	var input_range  = (inp_max - inp_min);
	var output_range = (out_max - out_min);

	return (input - inp_min) * output_range / input_range + out_min;



}
