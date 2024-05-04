/// @desc

#region functions
function set_list_visible () begin
	for (var i = 0; i < array_size(l_list); i++)
	{
		layer_set_visible(l_list[i], visible);
		
		if (l_deactivate_instances)
		{
			if (visible)
			{
				instance_activate_layer(l_list[i]);	
			
			}
			else
			{
				instance_deactivate_layer(l_list[i]);
			
			}
			
		}
		
	}

end


function set_vis (vis_state) begin
	visible = vis_state;
	toggled = vis_state;
	set_list_visible();
	
end


#endregion

i_init = false
visible = l_startVisible;
toggled = l_startVisible;

l_list = [];

//really REALLY shitty hack
//ie ehehhhghhh got the "begin" and "end" mixed up
//just be aware that this is working on the depth ordering in the room,
//which tldr: objects with higher depth are executed after ones with a lower depth
//why? fuck you.

//post note, this isnt true. you can change execution order in the room editor
//i think i meant smth about draw order being unintuitive in the room editor
var _b = l_begin;
l_begin = l_end;
l_end = _b;

l_begin = layer_get_id(l_begin);
l_end   = layer_get_id(l_end);

if (l_begin != l_end)
{
	if (
		(layer_exists(l_begin) && layer_exists(l_end)) 
		&& layer_get_depth(l_begin) > layer_get_depth(l_end)
	)
	{
		var _bd = layer_get_depth(l_begin);
		var _ed = layer_get_depth(l_end);
	
		for (var i = _bd; i >= _ed; i--)
		{
			var _lgiad = layer_get_id_at_depth(i);
		
			if (_lgiad[0] != -1)
			{
				array_copy(
					l_list, array_size(l_list), 
					_lgiad,
					0,
					array_size(_lgiad)
				);
			
			}
		
		}
	
	}
	
}
else if (l_begin == l_end)
{
	if (layer_exists(l_begin))
	{
		var _lgiad = layer_get_id_at_depth(layer_get_depth(l_begin));
		if (_lgiad[0] != -1)
		{
			array_copy(
				l_list, array_size(l_list), 
				_lgiad,
				0,
				array_size(_lgiad)
			);
			
			//print(layer_get_name(_lgiad[0]));
			
		}
		
	}
	
}

if (l_loose != noone && is_array(l_loose))
{
	var lyr;
	if (array_size(l_list) != 0) { lyr = l_list[array_size(l_list) - 1]; }
	
	for (var i = 0; i < array_size(l_loose); ++i)
	{
		var n = l_loose[i];
		if (layer_exists(n))
		{
			l_loose[i] = layer_get_id(n);
		}
		
	}
	
	array_copy(
		l_list, min(array_size(l_list) - 1, 0),
		l_loose, 0, array_size(l_loose)
	);
	
	if (array_size(l_list) != 0) { l_list[array_size(l_list)] = lyr; }
	
}

if (script_exists(l_beginScript) && script_exists(l_endScript))
{
	layer_script_begin(l_list[0], l_beginScript);
	layer_script_end(l_list[array_size(l_list) - 1], l_endScript);
	
}
