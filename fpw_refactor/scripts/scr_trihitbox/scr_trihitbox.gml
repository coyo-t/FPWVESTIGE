function Tri_Hitbox () : AABB_2d(0, 0, 0, 0) constructor begin
	points = [];
	
	///@func load_legacy(filepath)
	static load_legacy = function (_path)
	{
		var bff = buffer_load(_path);
		buffer_seek(bff, seek_set, 0);
	
		x0 = buffer_read(bff, f32);
		y0 = buffer_read(bff, f32);
		x1 = buffer_read(bff, f32);
		y1 = buffer_read(bff, f32);
	
		var point_count = buffer_read(bff, u32);
	
		repeat (point_count)
		{
			var tx = buffer_read(bff, f32);
			var ty = buffer_read(bff, f32);
			array_push(points, tx, ty);
		}
	
		buffer_delete(bff);
		
		return self;
	}
	
	///@func point_inside(x, y)
	static point_inside = function (px, py)
	{
		if (!point_in_rectangle(px, py, x0, y0, x1, y1))
		{
			return false;
		}
		
		var l = array_length(points);
			
		for (var i = 0; i < l;)
		{
			var tx1 = points[i++]; var ty1 = points[i++];
			var tx2 = points[i++]; var ty2 = points[i++];
			var tx3 = points[i++]; var ty3 = points[i++];
				
			var is_in = point_in_triangle(px, py, tx1, ty1, tx2, ty2, tx3, ty3);
				
			if (is_in)
			{
				return true;
			}
		}
		
		return false;
	}
	
	///@func draw()
	static draw = function ()
	{
		draw_push_state();
		draw_set_alpha(0.8);
		
		var l = array_length(points);
		
		draw_set_colour(c_orange);
		for (var i = 0; i < l;)
		{
			var tx1 = points[i++]; var ty1 = points[i++];
			var tx2 = points[i++]; var ty2 = points[i++];
			var tx3 = points[i++]; var ty3 = points[i++];
			
			draw_triangle(tx1, ty1, tx2, ty2, tx3, ty3, 1);
			
		}
		
		draw_set_colour(c_green);
		draw_rectangle(x0, y0, x1 - 1, y1 - 1, 1);

	
		draw_pop_state();
		
	}
	
	///@func offset(ofs_x, ofs_y)
	static offset = function (_xo, _yo)
	{
		x0 += _xo;
		x1 += _xo;
		y0 += _yo;
		y1 += _yo;
		
		var l = array_length(points)
			
		for (var i = 0; i < l;)
		{
			points[@i] += _xo;
			i++;
			points[@i] += _yo;
			i++;
		}
		
		return self;
	}
	
	///@func clone()
	static clone = function ()
	{
		var n = (new Tri_Hitbox()).set_aabb(x0, y0, x1, y1);
		array_copy(n.points, 0, points, 0, array_length(points));
		
		return n;
	}
	
end

