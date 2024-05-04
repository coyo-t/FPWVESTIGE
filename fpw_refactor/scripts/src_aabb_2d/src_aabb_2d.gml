///@func AABB_2d
///@arg x_left
///@arg y_top
///@arg x_right
///@arg y_bottom
function AABB_2d (l, t, r, b) constructor begin
	x0 = l;
	y0 = t;
	x1 = r;
	y1 = b;
	
	///@func point_inside(x, y)
	static point_inside = function (px, py)
	{
		return (
			px > x0 &&
			px < x1 &&
			py > y0 &&
			py < y1
		);
	}
	
	///@func draw()
	static draw = function ()
	{
		draw_rectangle(x0, y0, x1 - 1, y1 - 1, true);
	}
	
	///@func set_aabb
	///@arg x_left
	///@arg y_top
	///@arg x_right
	///@arg y_bottom
	static set_aabb = function (l, t, r, b)
	{
		x0 = l;
		y0 = t;
		x1 = r;
		y1 = b;
		
		return self;
	}
	
	///@func from_instance_bbox
	///@arg instance_id
	static from_instance_bbox = function (_obj_id)
	{
		_obj_id = is_undefined(_obj_id) ? other : _obj_id;
		
		if (instance_exists(_obj_id))
		{
			x0 = _obj_id.bbox_left;
			y0 = _obj_id.bbox_top;
			x1 = _obj_id.bbox_right;
			y1 = _obj_id.bbox_bottom;
		}
		
		return self;
	}
	
	///@func from_sprite_bbox
	///@arg sprite_id
	static from_sprite_bbox = function (_spr_id)
	{
		if (sprite_exists(_spr_id))
		{
			x0 = sprite_get_bbox_left(_spr_id);
			y0 = sprite_get_bbox_top(_spr_id);
			x1 = sprite_get_bbox_right(_spr_id);
			y1 = sprite_get_bbox_bottom(_spr_id);
		}
		
		return self;
	}
	
	///@func vs_aabb(AABB_2d_obj)
	static vs_aabb = function (_aabb)
	{
		return rectangle_in_rectangle(
			self.x0, self.y0,
			self.x1, self.y1,
			_aabb.x0, _aabb.y0,
			_aabb.x1, _aabb.y1
		);
	}
	
	///@func vs_bbox(instance_id)
	static vs_bbox = function (_id)
	{
		_id = is_undefined(_id) ? other : _id;
		
		return rectangle_in_rectangle(
			self.x0,
			self.y0,
			self.x1,
			self.y1,
			_id.bbox_left,
			_id.bbox_top,
			_id.bbox_right,
			_id.bbox_bottom
		);
	}
	
	///@func offset(ofs_x, ofs_y)
	static offset = function (_xo, _yo)
	{
		x0 += _xo;
		x1 += _xo;
		y0 += _yo;
		y1 += _yo;
		
		return self;
	}
	
	///@func clone()
	static clone = function ()
	{
		return new AABB_2d(x0, y0, x1, y1);
	}
	
	///@func clone_offset(xoffset, yoffset)
	static clone_offset = function (_xo, _yo)
	{
		return self.clone().offset(_xo, _yo);
	}
	
	///@func expand(xfat, yfat)
	static expand = function (_xo, _yo)
	{
		x0 -= _xo;
		y0 -= _yo;
		x1 += _xo;
		y1 += _yo;
		
		return self;
	}
	
	///@func clone_expand(xfat, yfat)
	static clone_expand = function (_xo, _yo)
	{
		return self.clone.expand(_xo, _yo);
	}
end
