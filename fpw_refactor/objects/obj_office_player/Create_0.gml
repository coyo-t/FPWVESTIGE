//x = 0;
y = 0;

is_enabled = true;
hard_stop = false;

trigger_size_max = 420; //further than this gives the max value, and it must be larger than trigger_size
trigger_size_min = trigger_size_max * (2/3);

limit_min = 0;
limit_max = room_width - view_wport[0];

inactive_l = 0 + trigger_size_max;
inactive_r = view_wport[0] - trigger_size_max;

velocity = 0;

spd_max = 1450;
spd_accel = 555;
spd_decel = 700;

int_x = 0;

function set_enable (is)
{
	is_enabled = is;
}
