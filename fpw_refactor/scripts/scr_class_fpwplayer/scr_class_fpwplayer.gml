function Fpw_Player () : Fpw_Entity () constructor begin
	eye_height = 3.1081;
	panic = new Fpw_Panic();
	
	///@func tick(gamestate)
	static tick = function (_gs)
	{
		var movespd = .5;
		
		ox = x;
		oy = y;
		oz = z;
		oap = ap;
		oay = ay;
		oar = ar;

		var toggle = _gs.input.vore_down("togglepanic");
		
		var r_spd = keyboard_check(ord("D")) - keyboard_check(ord("A"));
		var f_spd = keyboard_check(ord("W")) - keyboard_check(ord("S"));
		var v_spd = (keyboard_check(vk_shift) - keyboard_check(vk_control)) * movespd;
		
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
			panic.ofs_target(_gs.input.mwheel * .01);
		}
		
		panic.tick();
		
		ar *= .65 + (.2 * panic.fac);
		
		if (_gs.input.vore_down("reset_player_pos"))
		{
			set_loc_no_history(0, 0, 0);
		}
	}
	
	static kill = function ()
	{
		delete panic;
	}
end
