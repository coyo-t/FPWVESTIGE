///@func Timer
///@param ticks_per_second
function Timer (_tps) constructor begin
	static __MS_PER_SECOND = 1000000;
	static __MAX_MS_PER_UPD = 1000000;
	static __MAX_TICKS_PER_UPD = 100;
	
	__ticks_per_second = _tps;
	__last_time = get_timer();
	
	ticks = 0;
	time_scale = 1.;
	passed_time = 0.;
	time = 0.;
	est_fps = 0.;
	a = 0.;
	dt = 0.;
	
	__pause = false;
	__unpause = false;
	__pause_soft = false;
	
	tickroutine = -1;
	
	static update = function (_context)
	{
		advance_time();
		
		if (ticks <= 0 or tickroutine == -1)
		{
			return false;
		}
		
		for (var t = ticks; t > 0; --t)
		{
			if (is_undefined(_context))
			{
				tickroutine();
				continue;
			}
			
			var rt = tickroutine;
			with (_context)
			{
				rt();
			}
		}
		
		return true;
	}
	
	///@func advance_time()
	static advance_time = function ()
	{
		if (__pause)
		{
			return;
		}
		
		var now = get_timer();
		
		if (__unpause)
		{
			__last_time = now;
			__unpause = false;
		}
		
		var passed_ms = now - __last_time;
		__last_time = now;
		
		dt = passed_ms / __MS_PER_SECOND;
		
		passed_ms = clamp(passed_ms, 0, __MAX_MS_PER_UPD);
		
		est_fps = __MS_PER_SECOND / passed_ms;
		passed_time += passed_ms * time_scale * __ticks_per_second / __MS_PER_SECOND;
		ticks = floor(passed_time);
		
		ticks = min(ticks, __MAX_TICKS_PER_UPD);
		
		passed_time -= ticks;
		
		if (!__pause_soft)
		{
			time += dt;
			a = passed_time;
		}
	}
	
	static pause = function ()
	{
		__pause = true;
	}
	
	static unpause = function ()
	{
		__pause = false;
		__unpause = true;
	}
	
	static soft_pause = function ()
	{
		__pause_soft = true;
	}
	
	static soft_unpause = function ()
	{
		__pause_soft = false;
	}
	
	///@func get_tps()
	static get_tps = function ()
	{
		return __ticks_per_second;
	}
end
