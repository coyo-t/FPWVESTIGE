layers = [];
layers_len = 0;


///@arg is_visible
function set_visible (is_vis)
{
	for (var i = 0; i < layers_len;)
	{
		layer_set_visible(layers[i++], is_vis);
	}
}


///@arg names_array
function set_layers (arr)
{
	layers = [];
	layers_len = 0;
	
	for (var i = 0; i < array_length(arr); i++)
	{
		array_push(layers, layer_get_id(arr[i]));
		
	}
	
	layers_len = array_length(layers);
	
}
