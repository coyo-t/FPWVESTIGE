/// @desc
function affect_drain (_multi) begin
	drain_rate += drain_ads * _multi;

end


level_max = 555;
level = level_max;
drain_rate = -2.;
played_sound = false;
is_enabled = true;
drain_ads = -1;
