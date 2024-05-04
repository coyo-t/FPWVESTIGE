/// @desc

switch (obj_labyrinth_visuals.state)
{
	case room_states.power_out:
		draw_sprite(spr_t_room_powerout, 0, 0, 0);
		draw_sprite(spr_t_room_powerout, 1, room_width *.5, 0);
	break;
	
	case room_states.lizz:
		draw_sprite(spr_t_room, 0, 0, 0);
		draw_sprite(spr_t_room, 1, room_width *.5, 0);
	
	break;
	
	case room_states.grun_kill:
		draw_sprite_ext(spr_t_room_grunkill, 0, 0, 0, 2, 2, 0, c_white, 1.);
	break;
	
}
