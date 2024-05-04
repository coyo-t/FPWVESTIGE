// Based on java.util.Random
// http://developer.classpath.org/doc/java/util/Random-source.html
// https://docs.oracle.com/javase/8/docs/api/java/util/Random.html

///@func  Random
///@param [seed]
function Random (_seed) constructor begin
	static __seed_and = ((1 << 48) - 1)
	__have_next_next_gaussian = false;
	__next_next_gaussian = 0.;
	__seed = 0;

#region methods
	///@func set_seed(new_seed)
	static set_seed = function (new_seed)
	{
		__seed = (new_seed ^ $5deECe66d) & __seed_and;
		__have_next_next_gaussian = false;
	}
	
	///@func __next(bits)
	static __next = function (bits)
	{
		__seed = (__seed * $5deECe66d + $b) & __seed_and;
		return (__seed >> (48 - bits)) & $ffFFffFF;
	}
	
	///@func next_int()
	static next_int = function ()
	{
		return __next(32);
	}
	
	///@func next_int_bound(upper_bound)
	static next_int_bound = function (bound)
	{
		if (bound <= 0) then
			throw ("bounds must be positive");
			
		if ((bound & -bound) == bound) then
			return ((bound * __next(31)) >> 31) & $FFffFFff;
			
		var bits, val;
		do {
			bits = __next(31);
			val = bits % bound;
		} until not (bits - val + (bound - 1) < 0)
			
		return val & $FFffFFff;
	}
	
	///@func next_i64()
	static next_i64 = function ()
	{
		return (__next(32) << 32) | __next(32);
	}
	
	///@func next_bool()
	static next_bool = function ()
	{
		return __next(1) != 0;
	}
	
	///@func next_f32()
	static next_f32 = function ()
	{
		static diva = (1 << 24);
		return __next(24) / diva;
	}
	
	///@func next_f64()
	static next_f64 = function ()
	{
		static diva = (1 << 53);
		return ((__next(26) << 27) + __next(27)) / diva;
	}
	
	///@func next_gaussian
	static next_gaussian = function ()
	{
		if (__have_next_next_gaussian)
		{
			__have_next_next_gaussian = false;
			return __next_next_gaussian;
		}
		
		var v1, v2, s;
		do {
			v1 = 2. * next_f64() - 1.;
			v2 = 2. * next_f64() - 1.;
			s = v1 * v1 + v2 * v2;
		} until not (s >= 1 || s == 0)
		
		var norm = sqrt(-2 * ln(s) / s);
		__next_next_gaussian = v2 * norm;
		__have_next_next_gaussian = true;
		
		return v1 * norm;
	}
	
#endregion
	
#region constructor
	if (is_undefined(_seed))
	{
		_seed = date_second_span(date_create_datetime(1970, 1, 1, 0, 0, 0), date_current_datetime());
	}
	
	set_seed(_seed);
	
#endregion
end


///@func  RandomDt
///@param [fps_rate]
///@param [rate_type]
///@param [seed]
function RandomDt (_rate, _rate_type, _seed) : Random(_seed) constructor begin
	__last_time = -infinity;
	__last_val = 0;
	__rate_ms = 0;
	
	static __super__next = __next;
	
	///@func __next
	///@param bits
	static __next = function (_bits)
	{
		var t = get_timer();
		
		if (t > __last_time)
		{
			__last_val = __super__next(_bits);
			__last_time = t + __rate_ms;
		}
		
		return __last_val;
	}
	
	///@func set_rate
	///@param new_rate
	///@param rate_type
	static set_rate = function (_rate, _rate_type)
	{
		__last_time = -infinity;
		
		switch (_rate_type)
		{
			case gamespeed_fps:
				__rate_ms = 1000000 div _rate;
				break;
			case gamespeed_microseconds:
				__rate_ms = _rate;
				break;
			default:
				__rate_ms = game_get_speed(gamespeed_microseconds);
				break;
		}
	}
	
	
#region constructor
	if (is_undefined(_rate_type))
	{
		_rate_type = gamespeed_microseconds;
	}
	
	if (is_undefined(_rate))
	{
		__rate_ms = game_get_speed(gamespeed_microseconds);
		return;
	}
	
	set_rate(_rate, _rate_type);
#endregion
end
