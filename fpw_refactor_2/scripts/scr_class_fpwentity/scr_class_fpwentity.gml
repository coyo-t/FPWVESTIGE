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
	
	cleanup = false;
	
	aabb = new AABB(0,0,0, 1,1,1);
	
	mom = -1;
	
	has_interact_sound = true;
	
	///@func tick()
	static tick = function ()
	{
		ox = x;
		oy = y;
		oz = z;
		oap = ap;
		oay = ay;
		oar = ar;
		
		update_aabb_position();
	}
	
	///@func interact()
	interact = function ()
	{
		
	}
	
	///@func draw()
	static draw = function ()
	{
		var zt = gpu_get_zfunc();
		gpu_set_zfunc(cmpfunc_always);
		aabb.draw();
		//var vb = vertex_create_buffer();
		//vertex_begin(vb, global.vformat_xyz_col);
		//var c = draw_get_colour_argb();
		//var osz = 0.5;
		//draw_line_3d(vb, x-osz,y,z,x+osz,y,z,c);
		//draw_line_3d(vb, x,y-osz,z,x,y+osz,z,c);
		//draw_line_3d(vb, x,y,z-osz,x,y,z+osz,c);
		//vertex_end(vb);
		//vertex_submit(vb, pr_linelist, -1);
		//vertex_delete_buffer(vb);
		gpu_set_zfunc(zt);
	}
	
	///func free()
	static free = function ()
	{
		delete aabb;
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
	
	///@func set_position(new_x, new_y, new_z)
	static set_position = function (_nx, _ny, _nz)
	{
		x = _nx;
		y = _ny;
		z = _nz;
		update_aabb_position();
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
		update_aabb_position();
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
		
		var mag = 1. / sqrt(vx * vx + vy * vy + vz * vz);
		
		
		return [vx * mag * _len, vy * mag * _len, vz * mag * _len];
	}
	
	///@func set_aabb(width, hight, depth)
	static set_aabb = function(_w, _h, _d)
	{
		var hw = _w * .5;
		var hh = _h * .5;
		var hd = _d * .5;
		aabb.set_aabb(-hw, -hh, -hd, hw, hh, hd);
		update_aabb_position();
		return self;
	}
	
	///@func update_aabb_position()
	static update_aabb_position = function ()
	{
		aabb.set_position(x, y, z);
	}
	
	///@func mark_for_cleanup()
	static mark_for_cleanup = function ()
	{
		cleanup = true;
	}
end


function Fpw_CctvFlipper () : Fpw_Entity() constructor begin
	anim_sprite = spr_cam_flip;
	anim_direction = 0;
	anim_speed = sprite_get_speed(anim_sprite);
	anim_frame_count = sprite_get_number(anim_sprite) - 1;
	
	anim_frame = -1;
	anim_oframe = anim_frame;
	anim_target = -1;
	
	visible = false;
	
	fire_target_events = true;
	
	hold_frame = false;
	
	delete aabb;
	
	flip_up_cooldown_maxtime = .5;
	flip_up_cooldown = 0;
	
	flip_up_end = function () {}
	
	static tick = function ()
	{
		anim_oframe = anim_frame;
		hold_frame = false;
		
		if (is_animating())
		{
			anim_frame += (anim_speed/mom.timer.get_tps()) * anim_direction;
	
			//we're flipping up
			if (anim_direction == 1 && anim_frame >= anim_target)
			{
				if (fire_target_events)
				{
					flip_up_end();
				}

				anim_direction = 0;
				hold_frame = true;
			}
	
			//we're flipping down
			if (anim_direction == -1 && anim_frame <= anim_target)
			{
				anim_direction = 0;
				hold_frame = true;
			}
		}
	}
	
	static draw = function ()
	{
		if (is_animating() or hold_frame)
		{
			var fr = floor(tlerp(anim_frame, anim_oframe, mom.timer.a));
			draw_sprite_stretched(
				anim_sprite, clamp(fr, 0, anim_frame_count),
				x, y,
				mom.ref_w, mom.ref_h,
			);
		}
	}
	
	static flip_up = function (keep_frame = true)
	{
		if (not keep_frame)
		{
			anim_frame = 0;
			anim_oframe = 0;
		}
		
		anim_direction = 1;
		anim_target = anim_frame_count;
		mom.view_office.set_interaction(false);
		
		mom.achannels.transitions.play_sound(sfx_cam_up, .5);
		
		//if (audio_is_playing(sfx))
		//	audio_stop_sound(sfx);
	
		//sfx = audio_play_sound(sfx_cam_up, 1, false);
		//audio_sound_gain(sfx, 0.5, 0);
	
	}

	static flip_down = function (keep_frame)
	{
		if (keep_frame == undefined || !keep_frame)
		{
			anim_frame = anim_frame_count;
			anim_oframe = anim_frame_count;
		}
		
		anim_direction = -1;
		
		anim_target = 0;
		mom.change_view("office");
		mom.view_office.set_interaction(true);
		mom.achannels.transitions.play_sound(sfx_cam_down, .5);
		
		flip_up_cooldown = mom.timer.time;
		
		//if (audio_is_playing(sfx))
		//	audio_stop_sound(sfx);
	
		//sfx = audio_play_sound(sfx_cam_down, 1, false);
		//audio_sound_gain(sfx, 0.5, 0);

	}
	
	static cooldown_met = function ()
	{
		return mom.timer.time >= flip_up_cooldown + flip_up_cooldown_maxtime;
	}
	
	static can_flip = function ()
	{
		return (not is_animating()) and cooldown_met();
	}
	
	static is_animating = function ()
	{
		return (anim_direction != 0);
	}
end
