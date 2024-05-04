// Inherit the parent event
event_inherited();

#region functions
///@arg array
///@arg queue
function create_path (paths_array, queue) begin
	var pa_size = array_size(paths_array);
	var ip = 0;
	repeat (pa_size)
	{
		var paths = paths_array[ip++];
		var chosen = paths[irandom(array_size(paths) - 1)];
	
		for (var i = 0; i < array_size(chosen); i++)
		{
			ds_queue_enqueue(queue, chosen[i]);
		}
	
	}

end

__post_create_parent = post_create;

post_create = function () begin
	__post_create_parent();
	is_aggro_max = aggro_level == AI_MAX_LEVEL;
	
end


function trigger_scr () begin
	static countdown = -1; // seconds
	
	if (countdown = -1)
		countdown = irandom_range(8, 12);
	
	if (countdown <= 0)
	{
		countdown = -1;
		return true;
	} else {
		countdown -= dt();
		return false;
	}
	
end


#endregion

//is_enabled = false;

cooldown_max = 4;
cooldown_increase_rate = 1 + (1 - aggro_level / AI_MAX_LEVEL);

path_stack = ds_queue_create();

is_aggro_max = false;

paths_1 = [
	[
		"main_1",
		"main_3",
		"bedhall_2",
		"bedhall_1",
		"hall_r_2",
		"hall_r_1"
	],
	[
		"main_1",
		"main_3",
		"hall_r_1"
	]
];

paths_2 = [
	[
		"medi_3",
		"medi_2",
		"medi_1",
		"hall_l_1",
		"interro"
	],
	[
		"interro"
	]
];

create_path(
	[paths_1, paths_2],
	path_stack
);
