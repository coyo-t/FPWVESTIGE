enum OfficeStates {
	normal,
	breakin,
	powerdown
};

#region functions
function get_mouse_x ()
{
	return fpw.get_mouse_x() + camera_get_view_x(view_camera[0]);
}


function get_mouse_y ()
{
	return fpw.get_mouse_y() + camera_get_view_y(view_camera[0]);
}


function get_mouse_pos ()
{
	return [get_mouse_x(), get_mouse_y()];
}


function get_mouse_pano_pos ()
{
	var p = obj_office_panorama.remap_coord(
		fpw.get_mouse_x(),
		fpw.get_mouse_y(),
		0,
		0,
		view_wport[0],
		view_hport[0]
	);
	
	return [
		p[0] + camera_get_view_x(view_camera[0]), 
		p[1] + camera_get_view_y(view_camera[0])
	];
	
}


function set_interaction (_can_interact)
{
	for (var i = 0; i < array_length(lyr_interact); i++)
	{
		lyr_interact[i].set_enable(_can_interact);
	}
}


function set_enable (is)
{
	set_interaction(is);
	is_enabled = is;
	inst_l_mngr_office.set_visible(is);
}


#endregion

is_enabled = true;
state = OfficeStates.normal;

var thingy_layers = [
	"office_interactables"
];

lyr_interact = [];

for (var i = 0; i < array_length(thingy_layers); i++)
{
	var l_id   = layer_get_id(thingy_layers[i]);
	var things = layer_get_all_elements(l_id);

	for (var j = 0; j < array_length(things); j++)
	{
		array_push(lyr_interact, layer_instance_get_instance(things[j]))
	}
}

//load shit
texture_prefetch("maingameplay");

audio_listener_orientation(0, 0, 1000, 0, -1, 0);

#region layer controller setup
inst_l_mngr_office.set_layers([
	"pano",
	"office_interactables",
	"office_bkd",
	"office_screens",
]);


layer_script_begin("view_notrans_begin", scr_layer_notrans_begin);
layer_script_end("view_notrans_end", scr_layer_notrans_end);

#endregion

