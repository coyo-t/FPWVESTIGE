is_enabled = false;

view_mat = camera_get_view_mat(view_camera[0]);


var thingy_layers = [
	"cctv_interact"
];

lyr_interact = [];

for (var i = 0; i < array_length(thingy_layers); i++)
{
	var l_id   = layer_get_id(thingy_layers[i]);
	var things = layer_get_all_elements(l_id);

	for (var j = 0; j < array_length(things); j++)
	{
		array_push(lyr_interact, layer_instance_get_instance(things[j]));
	}
}


function set_interaction (_can_interact)
{
	for (var i = 0; i < array_length(lyr_interact); i++)
	{
		var ob = lyr_interact[i];
		if (ob.set_enable != -1)
			ob.set_enable(_can_interact);
	}
}


function set_enable (is)
{
	set_interaction(is);
	is_enabled = is;
	inst_l_mngr_cctv.set_visible(is);
}


#region layer thingy setup
inst_l_mngr_cctv.set_layers([
	"cctv_interact",
	"cctv_decor",
	"cctv_bkd"
]);

inst_l_mngr_cctv.set_visible(false);

#endregion
