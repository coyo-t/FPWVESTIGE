function EntityInteractTest (_gs) : Fpw_Entity(_gs) constructor begin
	aabb = new AABB(0, 0, 0, 10, 10, 10);
	is_on = false;
	
	///@func set_aabb(width, hight, depth)
	static set_aabb = function(_w, _h, _d)
	{
		var hw = _w * .5;
		var hh = _h * .5;
		var hd = _d * .5;
		aabb.set_aabb(x - hw, y - hh, z - hd, x + hw, y + hh, z + hd);
		return self;
	}
	
	///@func interact(gamestate)
	interact = function (_gs)
	{
		is_on ^= 1;
	}
	
	
	static draw = function(_gs)
	{
		var c = is_on ? $FF00FF00 : $FFFF0000;
		var dc = draw_get_colour();
		var zt = gpu_get_zfunc();
		gpu_set_zfunc(cmpfunc_always);
		draw_set_colour(c);
		aabb.draw();
		gpu_set_zfunc(zt);
		draw_set_colour(dc);
	}
end


function EntityInteractTest_cctv_switch (_gs) : EntityInteractTest(_gs) constructor begin
	///@func interact(gamestate)
	interact = function (_gs)
	{
		_gs.state_room.cctv_transition.flip_up(_gs, false);
		//_gs.queue_state_change("cctv");
	}
	
end
