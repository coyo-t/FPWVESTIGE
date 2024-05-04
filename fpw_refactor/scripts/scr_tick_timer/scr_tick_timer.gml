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
	est_fps = 0.;
	a = 0.;
	dt = 0;
	
	///@func advance_time()
	static advance_time = function ()
	{
		var now = get_timer();
		var passed_ms = now - __last_time;
		__last_time = now;
		
		dt = passed_ms / __MS_PER_SECOND;
		
		passed_ms = clamp(passed_ms, 0, __MAX_MS_PER_UPD);
		
		est_fps = __MS_PER_SECOND / passed_ms;
		passed_time += passed_ms * time_scale * __ticks_per_second / __MS_PER_SECOND;
		ticks = floor(passed_time);
		
		ticks = min(ticks, __MAX_TICKS_PER_UPD);
		
		passed_time -= ticks;
		a = passed_time;
	}
	
	///@func get_tps()
	static get_tps = function ()
	{
		return __ticks_per_second;
	}
end
