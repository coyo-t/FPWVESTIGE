function vec2 (_x, _y) constructor begin
	x = _x;
	y = _y;
end

function vec3 (_x, _y, _z) : vec2 (_x, _y) constructor begin
	z = _z;
end

function rect (_l, _t, _r, _b) constructor begin
	l = _l;
	t = _t;
	r = _r;
	b = _b;
	
	static vs_rect = function (o_rect) begin
		return rectangle_in_rectangle(
			self.l, self.t, self.r, self.b,
			o_rect.l, o_rect.t, o_rect.r, o_rect.b
		) != 0;
	end
	
	static vs_point = function (px, py) begin
		return point_in_rectangle(px, py, self.l, self.t, self.r, self.b);
	end
	
	static vs_vec2 = function (point) begin
		return self.vs_point(point.x, point.y);
	end
	
	static get_width = function () begin
		return abs(r - l);
	end
	
	static get_height = function () begin
		return abs(b - t);
	end
	
end