enum InputKeyType
{
	keyboard,
	mouse
}

function InputMap () constructor begin
	keys = ds_map_create();
	mwheel = 0;
	
	///@func vore_down(key)
	static vore_down = function (_key)
	{
		if (ds_map_exists(keys, _key))
		{
			return keys[?_key].vore_down();
		}
		return false;
	}
	///@func vore_up(key)
	static vore_up = function (_key)
	{
		if (ds_map_exists(keys, _key))
		{
			return keys[?_key].vore_up();
		}
		return false;
	}
	
	///@func is_key_held(key)
	static is_key_held = function (_key)
	{
		if (ds_map_exists(keys, _key))
		{
			return keys[?_key].is_held;
		}
		return false;
	}
	
	static update = function ()
	{
		var k = ds_map_values_to_array(keys);
		mwheel += mouse_wheel_up() - mouse_wheel_down();
		
		for (var i = 0; i < array_length(k); i++)
		{
			var kent = k[i]
			var kcode = kent.key;
			
			kent.set_hold(kent.__held_func(kcode))
			
			if (kent.__down_func(kcode))
			{
				kent.press_down();
			}
			
			if (kent.__up_func(kcode))
			{
				kent.press_up();
			}
		}
	}
	
	static end_update = function ()
	{
		clear_all();
	}
	
	static clear_all = function ()
	{
		var k = ds_map_values_to_array(keys);
		mwheel = 0;
		
		for (var i = 0; i < array_length(k); i++)
		{
			k[i].clear();
		}
	}
	
	///@func add(name, keycode, type)
	static add = function (_name, _keycode, _type)
	{
		var k = new InputKey(_name, _keycode, _type);
		keys[? _name] = k;
		return k;
	}
	
	static free = function ()
	{
		var k = ds_map_values_to_array(keys);
		for (var i = 0; i < array_length(k); i++)
		{
			delete k[i];
		}
		
		ds_map_destroy(keys)
	}
end


///@func InputKey (name, keycode, type)
function InputKey (_name, _key, _type) constructor begin
	name = _name;
	key = _key;
	type = _type;
	
	down_count = 0;
	up_count   = 0;
	is_held = false;
	
	__down_func = -1;
	__up_func   = -1;
	__held_func = -1;
	
	switch (_type)
	{
		case InputKeyType.keyboard:
			__down_func = keyboard_check_pressed;
			__up_func   = keyboard_check_released;
			__held_func = keyboard_check;
			break;
		case InputKeyType.mouse:
			__down_func = mouse_check_button_pressed;
			__up_func   = mouse_check_button_released;
			__held_func = mouse_check_button;
			break;
	}
	
	///@func press_down()
	static press_down = function ()
	{
		down_count++;
	}
	
	///@func press_up()
	static press_up = function ()
	{
		up_count++;
	}
	
	///@func clear()
	static clear = function ()
	{
		down_count = 0;
		up_count = 0;
		set_hold(false);
	}
	
	///@func set_hold(state)
	static set_hold = function (_state)
	{
		is_down = _state;
	}
	
	///@func vore_down()
	static vore_down = function()
	{
		if (down_count <= 0)
		{
			return false
		}
		
		down_count--;
		return true;
	}
	
	///@func vore_up()
	static vore_up = function()
	{
		if (up_count <= 0)
		{
			return false
		}
		
		up_count--;
		return true;
	}
	
end
