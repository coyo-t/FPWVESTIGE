function get_event_name() {
	switch (event_type)
	{
		case ev_create:  return "Create"; break;
		case ev_destroy: return "Destroy"; break;
		case ev_cleanup: return "Clean-up"; break;
	}

	if (event_type == ev_keyboard)
	{
		return "Keyboard " + chr(event_number);
	} 
	else if (event_type == ev_alarm)
	{
		return "Alarm " + string(event_number);
	}
	else if (event_type == ev_mouse)
	{
		switch (event_number)
		{
			case ev_left_press:
			case ev_left_release:
			case ev_left_button:   return "Mouse L held"; break;
			case ev_right_press:
			case ev_right_release:
			case ev_right_button:  return "Mouse R held"; break;
			case ev_middle_press:
			case ev_middle_release:
			case ev_middle_button: return "Mouse M held"; break;
			              default: return "Mouse " + string(event_number); break;
		}
	}
	else if (event_type == ev_gesture)
	{
		return "Gesture " + string(event_number);
	}
	else if (event_type == ev_collision)
	{
		return "Collide " + string(event_number);
	}
	else if (event_type == ev_other)
	{
		switch (event_number)
		{
			case ev_game_start: return "Game start"; break;
			case ev_game_end:   return "Game end";   break;
			case ev_room_start: return "Room start"; break;
			case ev_room_end:   return "Room end";   break;
			case ev_user0:
			case ev_user1:
			case ev_user2:
			case ev_user3:
			case ev_user4:
			case ev_user5:
			case ev_user6:
			case ev_user7:
			case ev_user8:
			case ev_user9:
			case ev_user10:
			case ev_user11:
			case ev_user12:
			case ev_user13:
			case ev_user14:
			case ev_user15:   return "User " + string(event_number - ev_user0); break;
			         default: return "Other " + string(event_number); break;
		}
	}
	else if (event_type == ev_draw)
	{
		switch (event_number)
		{
			case ev_draw:       return "Draw";       break;
			case ev_draw_begin: return "Draw begin"; break;
			case ev_draw_end:   return "Draw end";   break;
			case ev_draw_pre:   return "Pre draw";   break;
			case ev_draw_post:  return "Post draw";  break;
			case ev_gui:        return "Gui";        break;
			case ev_gui_begin:  return "Gui begin";  break;
			case ev_gui_end:    return "Gui end";    break;
			           default: return "Draw " + string(event_number); break;
		}
	}



}
