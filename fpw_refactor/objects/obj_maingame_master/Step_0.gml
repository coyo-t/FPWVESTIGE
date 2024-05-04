if (queued_state != -1)
{
	queued_state.on_switch_to(self);
	current_state = queued_state;
	queued_state = -1;
}

current_state.step(self);
timer.advance_time();
input.update();

if (timer.ticks > 0)
{
	for (var __i = 0; __i < timer.ticks; __i++)
	{
		while (input.vore_down("nuke"))
		{
			game_end();
		}
		
		player.tick(self);
		
		for (var i = 0; i < array_length(entities); i++)
		{
			entities[i].tick();
			
		}
		
		current_state.tick(self);
	}
	
	input.end_update();
	current_state.end_step(self);
}
