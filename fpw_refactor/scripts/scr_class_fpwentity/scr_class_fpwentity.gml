///@func Fpw_Entity
///@arg gamestate
function Fpw_Entity () constructor begin
	x = 0;
	y = 0;
	z = 0;
	
	ox = 0;
	oy = 0;
	oz = 0;
	
	ap = 0; // angle pitch
	ay = 0; //       yaw
	ar = 0; //       roll
	
	oap = 0;
	oay = 0;
	oar = 0;
	
	is_enabled = true;
	
	killme = false;
	
	///@func tick(gamestate)
	static tick = function (_gs)
	{
		ox = x;
		oy = y;
		oz = z;
		oap = ap;
		oay = ay;
		oar = ar;
	}
	
	///@func draw()
	static draw = function ()
	{
		
	}
	
	///func kill()
	static kill = function ()
	{
		
	}
	
	///@func turn(delta_yaw, delta_pitch)
	static turn = function (d_yaw, d_pitch)
	{
		ap = clamp(ap + d_pitch, -90, 90);
		ay += d_yaw;
		
		if (ay > 180)
		{
			ay -= 360;
		}
		
		if (ay < -180)
		{
			ay += 360;
		}
	}
	
	///@func tlerp (val, oval, t)
	static tlerp = function (_v, _ov, _t)
	{
		gml_pragma("forceinline");
		return ((_v - _ov) * _t + _ov);
	}
	
	///@func set_loc(new_x, new_y, new_z)
	static set_loc = function (_nx, _ny, _nz)
	{
		x = _nx;
		y = _ny;
		z = _nz;
		return self;
	}
	
	///@func set_loc_no_history(new_x, new_y, new_z)
	static set_loc_no_history = function (_nx, _ny, _nz)
	{
		x = _nx;
		y = _ny;
		z = _nz;
		ox = x;
		oy = y;
		oz = z;
		return self;
	}
	
	///@func get_look_vector(len)
	static get_look_vector = function (_len)
	{
		var ap_pi = radians(ap);
		var ay_pi = radians(ay);
		var pcos = cos(ap_pi);
		var vx = sin(ay_pi) * pcos;
		var vy = -sin(ap_pi);
		var vz = cos(ay_pi) * pcos;
		
		var mag = 1/sqrt(vx * vx + vy * vy + vz * vz);
		
		
		return [vx * mag * _len, vy * mag * _len, vz * mag * _len];
	}
	
	///@func mark_for_death()
	static mark_for_death = function ()
	{
		killme = true;
	}
end
