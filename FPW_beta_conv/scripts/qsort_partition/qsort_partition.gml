///@arg array
///@arg lo
///@arg hi
///@arg compare_func
function qsort_partition(argument0, argument1, argument2, argument3) {

	var lo = argument1;
	var hi = argument2;
	var func = argument3;

	var pivot = argument0[hi];
	var i = (lo - 1);

	for (var j = lo; j <= hi - 1; j++)
	{
		var cmp = script_execute(func, argument0[j], pivot);
		if (cmp)
		{
			i++;
			array_swap(argument0, i, j);
		}
	
	}

	array_swap(argument0, i + 1, hi);

	return (i + 1);



}
