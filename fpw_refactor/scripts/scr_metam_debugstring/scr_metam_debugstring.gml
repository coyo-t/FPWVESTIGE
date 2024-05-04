function MetaModule_DebugString (_m) : MetaModule(_m) constructor begin
	text = "";
	indent = 0;
	tab_size = 4;
	
	///@func set_indent_size(length)
	static set_indent_size = function (len)
	{
		if (indent > len)
		{
			text += "\n";
		}
		indent = len;
		return self;
	}
	
	///@func build_string(str)
	static build_string = function (s)
	{
		gml_pragma("forceinline");
		return (string_repeat("\t", indent) + s + "\n");
	}
	
	///@func queue_string(str)
	static queue_string = function (s)
	{
		text = build_string(s) + text;
		return self;
	}
	
	///@func push_string(str)
	static push_string = function (s)
	{
		text += build_string(s);
		return self;
	}
	
	///@func push_vec3(key, x, y, z)
	static push_vec3 = function (s, _x, _y, _z)
	{
		_x = string_format(_x, 0, 8);
		_y = string_format(_y, 0, 8);
		_z = string_format(_z, 0, 8);
		self.push_string(tostr(s)+" [\n\tx: "+_x+"\n\ty: "+_y+"\n\tz: "+_z+"\n]");
		return self;
	}
	
	///@func push_kv(key, value)
	static push_kv = function (s, v)
	{
		self.push_string(tostr(s)+": "+tostr(v));
		return self;
	}
	
	///@func queue_kv(key, value)
	static queue_kv = function (s, v)
	{
		self.queue_string(tostr(s)+": "+tostr(v));
		return self;
	}
	
	///@func group_begin(title)
	static group_begin = function (title)
	{
		self.push_string(title);
		indent++;
		return self;
	}
	
	///@func group_end()
	static group_end = function ()
	{
		indent--;
		//debug_string_push_string("}");
		return self;
	}
	
	///@func peek()
	static peek = function ()
	{
		return string_replace_all(text, "\t", "|"+string_repeat(" ", tab_size - 1));
	}
	
	///@func vore()
	static vore = function ()
	{
		var s = self.peek();
		indent = 0;
		text = "";
		return s;
	}
	
	
end
