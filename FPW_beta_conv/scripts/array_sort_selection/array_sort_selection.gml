///@arg array
///@arg compare_func
function array_sort_selection(argument0, argument1) {

	var compare_func = argument1;
	var i, j, ind_min;
	var size = array_size(argument0);

	for (i = 0; i < size - 1; i++)
	{
		ind_min = i;
	
		for (j = i + 1; j < size; j++)
		{
			var cmp = script_execute(compare_func, argument0[j], argument0[ind_min]);
			if (cmp)
				ind_min = j;
		
		}
	
		array_swap(argument0, ind_min, i);
	
	}



}
