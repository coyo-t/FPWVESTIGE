/// @desc
if (!is_enabled)
	exit;

screen_surface = surface_create_unexist(screen_surface, screen_size, screen_size);
surface_clear(screen_surface, c_black);

if (is_tv_on && obj_labyrinth_visuals.state == room_states.lizz)
{
	layer_set_visible(show_layer, true);
} else {
	layer_set_visible(show_layer, false);
}
