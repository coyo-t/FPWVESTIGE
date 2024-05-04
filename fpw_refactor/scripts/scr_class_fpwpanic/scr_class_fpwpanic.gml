function Fpw_Panic () constructor begin
	target = 0;
	target_spd = 0.1;
	
	fac = 0;
	ofac = 0;
	
	time = 0;
	otime = 0;
	time_rate = 0.1;
	
	static tick = function ()
	{
		otime = time;
		ofac  = fac;
		
		fac = lerp(fac, target, target_spd);
		time += fac * time_rate;
	}
	
	static set_fac = function (_new)
	{
		target = _new;
		fac = _new;
		ofac = _new;
	}
	
	static ofs_target = function (_new)
	{
		gml_pragma("forceinline");
		target = clamp(target+_new, 0., 1.);
	}
	
	static set_target = function (_new)
	{
		gml_pragma("forceinline");
		target = clamp(_new, 0., 1.);
	}
	
	static get_fac = function (a)
	{
		gml_pragma("forceinline");
		return ((fac - ofac) * a + ofac);
	}
	
	static get_time = function (a)
	{
		gml_pragma("forceinline");
		return ((time - otime) * a + otime);
	}

	static get_distortion_matrix = function (a)
	{
		var ff = get_fac(a);
		var tm = get_time(a);
		var pfc = ff;
		var namp = .5 * pfc * pfc * pfc;
		var nspd = 1.25;

		var n = sin(tm * pi * .25 * nspd) * .125 * namp;
		var m = cos(tm * pi * .25 * nspd) * .25  * namp;
		var o = (sin(tm * pi * .05 * nspd) * cos(tm * pi * .1 * nspd) * .5 + .5) * namp *.5;
			
		return [
			1,
			m,
			-m * .25,
			0,
				
			n * .5,
			1,
			m * .25,
			0,
				
			0,
			n * .25,
			1 - o,
			0,
				
			0,
			0,
			ff*ff*2,
			1
		];
	}
	
end
