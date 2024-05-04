///@arg array
///@arg lo
///@arg hi
///@arg compare_func
function array_qsort(argument0, argument1, argument2, argument3) {

	var lo = argument1;
	var hi = argument2;
	var func = argument3;

	if (lo < hi)
	{
		var p = qsort_partition(argument0, lo, hi, func);
	
		array_qsort(argument0, lo, p - 1, func);
		array_qsort(argument0, p + 1, hi, func);
	}



}
