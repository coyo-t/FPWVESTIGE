function Fpw_Player () : Fpw_Entity () constructor begin
	eye_height = 3.1081;
	panic = new Fpw_Panic();
	
	///@func tick()
	static tick = function ()
	{
		var movespd = .5;
		
		ox = x;
		oy = y;
		oz = z;
		oap = ap;
		oay = ay;
		oar = ar;

		var toggle = mom.input.vore_press("odebug.togglepanic");
		
		var r_spd = mom.input.get_down("odebug.plr_d") -  mom.input.get_down("odebug.plr_a");
		var f_spd = mom.input.get_down("odebug.plr_w") -  mom.input.get_down("odebug.plr_s");
		var v_spd = (mom.input.get_down("odebug.plr_u") -  mom.input.get_down("odebug.plr_b")) * movespd;
		
		if (r_spd != 0 or f_spd != 0 or v_spd != 0)
		{
			if (r_spd != 0 and f_spd != 0)
			{
				r_spd *= SQRT2;
				f_spd *= SQRT2;
			}
		
			r_spd *= movespd;
			f_spd *= movespd;
		
			var rady = radians(ay);
			var f_sin = sin(rady);
			var f_cos = cos(rady);
		
			var r_sin = sin(-rady);
			var r_cos = cos(-rady);
		
			x -= f_spd * f_sin + r_spd * r_cos;
			z -= r_spd * r_sin + f_spd * f_cos;
			y -= v_spd;
			
		}
		
		if (toggle)
		{
			if (panic.target > math_get_epsilon())
			{
				panic.target = 0;
			}
			else
			{
				panic.target = 1;
			}
		}
		else
		{
			panic.ofs_target(mom.input.get_mouse_wheel() * .01);
		}
		
		panic.tick();
		
		ar *= .65 + (.2 * panic.fac);
		
		if (mom.input.vore_press("odebug.plr_resetpos"))
		{
			set_loc_no_history(0, 0, 0);
		}
	}
	
	static draw = function ()
	{
		
	}
	
	static kill = function ()
	{
		delete panic;
	}
end
