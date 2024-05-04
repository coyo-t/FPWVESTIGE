function InputManager () constructor begin
	__map_all = ds_map_create();
	__map_groups = ds_map_create();
	__enabled_groups = ds_map_create();
	__mouse_wheel = 0;
	
	///@func add_input(group, name, keycode, type)
	static add_input = function (_group, _name, _keycode, _type)
	{
		if (!ds_map_exists(__map_groups, _group))
		{
			var m = ds_map_create();
			ds_map_add_map(__map_groups, _group, m);
			__enabled_groups[?_group] = true;
		}
		
		switch (string_lower(_type))
		{
			case "keyboard":
				_type = 0;
				break;
			case "mouse":
				_type = 1;
				break;
			default:
				_type = -1;
				break;
		}
		
		var inp = {
			is_down: false,
			press_count: 0,
			release_count: 0,
			group: _group,
			name: _name,
			type: _type,
			keycode: _keycode
		};
		
		__map_all[?_group+"."+_name] = inp;
		__map_groups[?_group][?_name] = inp;
	}
	
	///@func vore_press(input_name)
	static vore_press = function (_inpname)
	{
		if (!ds_map_exists(__map_all, _inpname))
		{
			return false;
		}
		
		var k = __map_all[?_inpname];
		if (k.press_count > 0)
		{
			k.press_count--;
			return true;
		}
		
		return false;
	}
	
	///@func vore_release(input_name)
	static vore_release = function (_inpname)
	{
		if (!ds_map_exists(__map_all, _inpname))
		{
			return false;
		}
		
		var k = __map_all[?_inpname];
		if (k.release_count > 0)
		{
			k.release_count--;
			return true;
		}
		
		return false;
	}
	
	///@func get_down(input_name)
	static get_down = function (_inpname)
	{
		if (!ds_map_exists(__map_all, _inpname))
		{
			return false;
		}
		
		return __map_all[?_inpname].is_down;
	}
	
	
	static update_key = function (_k)
	{
		if (_k == -1)
		{
			return;
		}
		
		var _code = _k.keycode;
		switch (_k.type)
		{
			case 0:
				_k.is_down |= keyboard_check(_code);
				_k.press_count += keyboard_check_pressed(_code);
				_k.release_count += keyboard_check_released(_code);
				break;
			case 1:
				_k.is_down |= mouse_check_button(_code);
				_k.press_count += mouse_check_button_pressed(_code);
				_k.release_count += mouse_check_button_released(_code);
				break;
		}
	}
	
	static get_input = function (_name)
	{
		if (ds_map_exists(__map_all, _name))
		{
			return __map_all[?_name];
		}
		return -1;
	}
	
	static clear_key = function (_k)
	{
		if (_k == -1)
		{
			return;
		}
		_k.is_down = false;
		_k.press_count = 0;
		_k.release_count = 0;
	}
	
	static update_mwheel = function ()
	{
		__mouse_wheel += mouse_wheel_up() - mouse_wheel_down();
	}
	
	static update_all = function ()
	{
		update_mwheel();
		
		var vs = ds_map_values_to_array(__map_all);
		for (var i = 0, k = array_length(vs); i < k; i++)
		{
			var ks = vs[i];
			
			if (__enabled_groups[?ks.group])
			{
				update_key(ks);
			}
		}
	}
	
	static flush_all = function ()
	{
		__mouse_wheel = 0;
		
		var vs = ds_map_values_to_array(__map_all);
		for (var i = 0, k = array_length(vs); i < k; i++)
		{
			var ks = vs[i];
			
			clear_key(ks);
		}
	}
	
	static update_group = function (_group)
	{
		if (!ds_map_exists(__map_groups, _group) or !__enabled_groups[?_group])
		{
			return;
		}
		
		var vs = ds_map_values_to_array(__map_groups[?_group]);
		for (var i = 0, k = array_length(vs); i < k; i++)
		{
			var ks = vs[i];
			
			update_key(ks);
		}
	}
	
	static flush_group = function (_group)
	{
		if (!ds_map_exists(__map_groups, _group))
		{
			return;
		}
		
		var vs = ds_map_values_to_array(__map_groups[?_group]);
		for (var i = 0, k = array_length(vs); i < k; i++)
		{
			var ks = vs[i];
			
			clear_key(ks);
		}
	}
	
	static set_group_enable = function (_group, _state)
	{
		if (!ds_map_exists(__map_groups, _group))
		{
			return;
		}
		__enabled_groups[?_group] = _state;
		
		if (!_state)
		{
			flush_group(_group);
		}
	}
	
	static get_mouse_wheel = function ()
	{
		return __mouse_wheel;
	}
	
	static free = function ()
	{
		ds_map_destroy(__map_all);
		ds_map_destroy(__map_groups);
		ds_map_destroy(__enabled_groups);
	}
	
end
