///@func AABB
///@arg x0
///@arg y0
///@arg z0
///@arg x1
///@arg y1
///@arg z1
function AABB (_x0=0, _y0=0, _z0=0, _x1=0, _y1=0, _z1=0) constructor begin
	x = 0;
	y = 0;
	z = 0;
	
	x0 = _x0;
	x1 = _x1;
	y0 = _y0;
	y1 = _y1;
	z0 = _z0;
	z1 = _z1;
	
	///@func point_inside(x, y, z)
	static point_inside = function (px, py, pz)
	{
		px -= x;
		py -= y;
		pz -= z;
		
		return (
			px > x0 &&
			px < x1 &&
			py > y0 &&
			py < y1 &&
			pz > z0 &&
			pz < z1
		);
	}
	
	///@func draw()
	static draw = function ()
	{
		var vb = vertex_create_buffer();
		vertex_begin(vb, _G.vformat_xyz_col);
		draw_cube_outline(
			vb,
			x0 + x, y0 + y, z0 + z,
			x1 + x, y1 + y, z1 + z,
			draw_get_colour_argb()
		);
		vertex_end(vb);
		vertex_submit(vb, pr_linelist, -1);
		vertex_delete_buffer(vb);
	}
	
	///@func set_aabb(x0, y0, z0, x1, y1, z1)
	static set_aabb = function (_x0, _y0, _z0, _x1, _y1, _z1)
	{
		x0 = _x0;
		x1 = _x1;
		y0 = _y0;
		y1 = _y1;
		z0 = _z0;
		z1 = _z1;
		
		return self;
	}
	
	///@func vs_aabb(AABB_obj)
	static vs_aabb = function (_aabb)
	{
		return (
			(_aabb.x1 + _aabb.x) > (x0 + x) &&
			(_aabb.x0 + _aabb.x) < (x1 + x) &&
			(_aabb.y1 + _aabb.y) > (y0 + y) &&
			(_aabb.y0 + _aabb.y) < (y1 + y) &&
			(_aabb.z1 + _aabb.z) > (z0 + z) &&
			(_aabb.z0 + _aabb.z) < (z1 + z)
		);
	}
	
	///@func vs_ray(_ray_orig, _ray_dir)
	static vs_ray = function (_pos, _dir)
	{
		_pos[0] -= x;
		_pos[1] -= y;
		_pos[2] -= z;
		
		var t1 = (x0 - _pos[0]) / _dir[0];
		var t2 = (x1 - _pos[0]) / _dir[0];
		var t3 = (y0 - _pos[1]) / _dir[1];
		var t4 = (y1 - _pos[1]) / _dir[1];
		var t5 = (z0 - _pos[2]) / _dir[2];
		var t6 = (z1 - _pos[2]) / _dir[2];
		
		var tmin = max(max(min(t1, t2), min(t3, t4)), min(t5, t6));
		var tmax = min(min(max(t1, t2), max(t3, t4)), max(t5, t6));
		
		if (tmax < 0 or tmin > tmax)
		{
			return -1;
		}
		
		if (tmin < 0)
		{
			return tmax
		}
		
		return tmin;
	}
	
	///@func offset(ofs_x, ofs_y, ofs_z)
	static offset = function (_xo, _yo, _zo)
	{
		x0 += _xo;
		x1 += _xo;
		y0 += _yo;
		y1 += _yo;
		z0 += _zo;
		z1 += _zo;
		
		return self;
	}
	
	///@func clone()
	static clone = function ()
	{
		var ab = new AABB_3d(x0, y0, x1, y1, z0, z1);
		ab.x = x;
		ab.y = y;
		ab.z = z;
		return ab;
	}
	
	///@func clone_offset(xoffset, yoffset, zoffset)
	static clone_offset = function (_xo, _yo, _zo)
	{
		return self.clone().offset(_xo, _yo, _zo);
	}
	
	///@func expand(xfat, yfat, zfat)
	static expand = function (_xo, _yo, _zo)
	{
		x0 -= _xo;
		x1 += _xo;
		y0 -= _yo;
		y1 += _yo;
		z0 += _zo;
		z1 += _zo;
		
		return self;
	}
	
	///@func clone_expand(xfat, yfat, zfat)
	static clone_expand = function (_xo, _yo, _zo)
	{
		return self.clone.expand(_xo, _yo, _zo);
	}
	
	///@func set_position(x, y, z)
	static set_position = function (_x, _y, _z)
	{
		x = _x;
		y = _y;
		z = _z;
	}
	
end
