turn_player(player, gamestate);
t.advance_time();
gamestate.input.update();

if (t.ticks > 0)
{
	entity_of_interest = -1;
	
	for (var i = 0; i < t.ticks; i++)
	{
		if (keyboard_check(vk_escape))
		{
			game_end();
		}
		
		// the player is a little bitch we wanna update removed from all else
		// so that theres no order of operations bullshit.
		// should we update them after all? try both before/after.
		player.tick(gamestate);
		
		for (var ie = 0, el = array_length(entities); ie < el; ie++)
		{
			var ee = entities[ie];
			ee.tick(gamestate);
		}
		
	}
	
	gamestate.input.end_update();
}
