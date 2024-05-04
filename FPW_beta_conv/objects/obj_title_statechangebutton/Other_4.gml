/// @desc
var l = bbox_left;
var r = bbox_right;
var t = bbox_top;
var b = bbox_bottom;

var rr = -1;

with (obj_title_cell)
{
	var is_in = rectangle_in_rectangle(
		l, t, r, b,
		bbox_left, bbox_top, bbox_right, bbox_bottom
	);
	
	if (is_in == 1)
	{
		rr = cell_name;
		
	}
	
}

resident_state = rr;

is_my_state = obj_title_controller.current_state_name() == resident_state;
