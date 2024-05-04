///@arg array
function array_sort_shuffle(argument0) {

	var size = array_size(argument0);

	for (var i = 0; i < size; i++)
	{
		array_swap(argument0, irandom(size - 1), irandom(size - 1));
	}




}
