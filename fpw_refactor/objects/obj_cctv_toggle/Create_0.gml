is_cctv_on = false;

lyr_in_office = layer_get_id("cctv_toggle_button");
lyr_in_cctv = layer_get_id("cctv_interact");

x_in_room = (view_wport[0] - sprite_width) / 2
x_in_cctv = x;

x = x_in_room;

is_enabled = true;

was_mouse_over = false;

hitbox = new AABB_2d(0, 0, 0, 0);

function set_cctv_state (is)
{
	is_cctv_on = is;
	
	if (is_cctv_on)
	{
		obj_office_director.set_enable(false);
		obj_cctv_director.set_enable(true);
		layer = lyr_in_cctv;
		x = x_in_cctv;
	}
	
	if (!is_cctv_on)
	{
		obj_office_director.set_enable(true);
		obj_cctv_director.set_enable(false);
		layer = lyr_in_office;
		x = x_in_room;
	}
	
}

flip_anim = obj_cctv_flipper;
is_flip_anim = false;
