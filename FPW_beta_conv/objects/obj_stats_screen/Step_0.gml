/// @desc
startup_ended = startup_timer == startup_timer_end;

startup_timer = animate_and_return(startup_anim, startup_timer, 1);
startup_timer = min(startup_timer, startup_timer_end);
			
startup_fade -= dt() * 2 * startup_ended;
startup_fade = max(startup_fade, 0.);
