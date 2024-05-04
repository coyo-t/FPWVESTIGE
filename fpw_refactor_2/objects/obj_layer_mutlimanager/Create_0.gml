layer_visible = -1;
layers = -1;
if (init_layers == -1)
{
	exit;
}

var len = array_length(init_layers);
layer_visible = [];
layer_names = ds_map_create();
layers = [];
layer_count = 0;
for (var i = 0; i < len; i++)
{
	var l = layer_get_id(init_layers[i]);

	if (l == -1)
	{
		continue;
	}
	
	array_push(layers, l);
	layer_names[? init_layers[i]] = layer_count;
	
	layer_count++;
	
	var vis = layer_get_visible(l);
	array_push(layer_visible, vis);
	layer_set_visible(l, vis and start_visible);
	
}


function get_layer (_name)
{
	if (ds_map_exists(layer_names, _name))
	{
		return layers[layer_names[? _name]];
	}
	return -1;
}


function set_all_visible (_vis)
{
	for (var i = 0; i < layer_count; i++)
	{
		var lay = layers[i];
		
		layer_set_visible(lay, _vis);
	}
}

