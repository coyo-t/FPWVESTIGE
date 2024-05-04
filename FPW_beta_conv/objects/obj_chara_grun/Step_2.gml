/// @desc
if (!is_enabled)
	exit;

event_inherited();

if (moved)
{
	ds_queue_dequeue(path_stack);
}

cooldown = min(cooldown, cooldown_max);
