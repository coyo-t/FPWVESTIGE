enum NbtTag
{
	End = 0,
	Byte,
	Short,
	Int,
	Long,
	Float,
	Double,
	Byte_Array,
	String,
	List,
	Compound,
	Int_Array,
	Long_Array
};

function NbtReader () constructor begin
	static __curr_bff = -1;
	static buffers = {};
	
	name = "";
	data = -1;
	
	///@func free()
	static free = function ()
	{
		gml_pragma("forceinline");
		__free_tags(data, 0);
	}
	
	///@func __free_tags
	///@param in_tag
	///@param depth
	static __free_tags = function (_in_tag, _depth)
	{
		if (is_struct(_in_tag))
		{
			if (instanceof(_in_tag) == "Buffer")
			{
				_in_tag.free();
				delete _in_tag;
				return;
			}
			
			var elem = variable_struct_get_names(_in_tag);
			var len = array_length(elem);
			
			for (var i = 0; i < len; i++)
			{
				var child = _in_tag[$ elem[i]];
				__free_tags(child, _depth + 1);
			}
		
			delete _in_tag;
			
			return;
		}
		
		if (is_array(_in_tag))
		{
			var len =  array_length(_in_tag);
			
			for (var i = 0; i < len; i++)
			{
				__free_tags(_in_tag[i], _depth + 1);
			}
			
			return;
		}
	}
	
	#region loading ------
	///@func parse
	///@param buffer
	static parse = function (f)
	{
		__curr_bff = f;
		
		if (!buffer_exists(f))
		{
			__curr_bff = -1;
			return -1;
		}
		
		try
		{
			// see if the NBT data is Zlib'd or not
			// todo: gzip??
			var comp = buffer_decompress(f);
			
			if (comp != -1)
			{
				__curr_bff = comp;
			}
		
		
			var type = read_byte();
		
			if (type != NbtTag.Compound)
			{
				throw ("Expected root compound tag, got "+tostr(type)+"!");
			}
		
			name = read_string();
			data = read_compound();
		}
		catch (e)
		{
			__curr_bff = -1;
			sdm(e);
		}
		finally
		{
			if (comp != -1)
			{
				buffer_delete(comp);
			}
		
			__curr_bff = -1;
			
		}
		
		return data;
	}
	
	#region read functions ------
	
	// TODO: improve me!
	// also dont be confused! java is big endian
	// thats why we check if we're little endian, and if so
	// use the big endian func.
	// i confused myself with this. oops
	static __read_be = function (f, type)
	{
		var mem = buffer_create(8, buffer_fixed, 1);
	
		for (var i = sizeof(type) - 1; i >= 0; i--)
		{
			buffer_poke(mem, i, u8, buffer_read(f, u8));
		}
		
		var outv = buffer_peek(mem, 0, type);
		buffer_delete(mem);
		
		return outv;
	}
	
	static __read_le = function (f, type)
	{
		return buffer_read(f, type);
	}
	
	//endianess bullshit ALFHDSKJFLHJAKSJH
	///@func __read
	///@param buffer
	///@param read_type
	static __read = (function (_be_func, _le_func) begin
		var b = buffer_create(2, buffer_fixed, 1);
		
		buffer_write(b, u16, 0x0001);
		
		var is = buffer_peek(b, 0, u8) != 0;
		
		buffer_delete(b);
	
		return is ? _be_func : _le_func;
	end)(__read_be, __read_le);
	
	///@func read_byte()
	static read_byte = function ()
	{
		gml_pragma("forceinline");
		return buffer_read(__curr_bff, s8);
	}
	
	///@func read_short()
	static read_short = function ()
	{
		gml_pragma("forceinline");
		return __read(__curr_bff, s16);
	}
	
	///@func read_ushort()
	static read_ushort = function ()
	{
		gml_pragma("forceinline");
		return __read(__curr_bff, u16);
	}
	
	///@func read_int()
	static read_int = function ()
	{
		gml_pragma("forceinline");
		return __read(__curr_bff, s32);
	}
	
	///@func read_long()
	static read_long = function ()
	{
		gml_pragma("forceinline");
		return __read(__curr_bff, s64);
	}
	
	///@func read_float()
	static read_float = function ()
	{
		gml_pragma("forceinline");
		return __read(__curr_bff, f32);
	}
	
	///@func read_double()
	static read_double = function ()
	{
		gml_pragma("forceinline");
		return __read(__curr_bff, f64);
	}
	
	///@func read_string()
	static read_string = function ()
	{
		var len = read_ushort();
		
		if (len == 0)
		{
			return "";
		}
	
		var tbuff = buffer_create(len, buffer_fixed, 1);
		buffer_copy(__curr_bff, buffer_tell(__curr_bff), len, tbuff, 0);
	
		var s = buffer_read(tbuff, text_t);
	
		buffer_delete(tbuff);
		buffer_seek(__curr_bff, seek_offset, len);
	
		return s;
	}
	
	///@func read_compound()
	static read_compound = function ()
	{
		var vals = {};
	
		while (true)
		{
			var t = read_byte();
		
			if (t == NbtTag.End)
			{
				break;
			}
			
			var name = read_string();
			var val = read_any(t);
		
			//vals[$ name] = {type: nbt_get_tag_name(t), data: val};
			vals[$ name] = val;
		
		}
	
		return vals;
	}
	
	///@func read_list()
	static read_list = function ()
	{
		var type = read_byte();
		var len  = read_int();
	
		var vals = array_create(len);
	
		var i = 0;
		repeat (len)
		{
			vals[i++] = read_any(type);
		}
		
		//return {type: type, data: vals};
		return vals;
	}
	
	///@func __read_array_generic
	///@param read_function
	static __read_array_generic = function (_read_func)
	{
		var len = read_int();
		var arr = array_create(len);
	
		var i = 0;
		repeat (len)
		{
			arr[i++] = _read_func();
		}
		
		return arr;
	}
	
	///@func read_byte_array()
	static read_byte_array = function ()
	{
		var len = read_int();
		var arr = new Buffer(len, buffer_fast, 1);
		arr.seek(seek_set, 0);
		
		var i = 0;
		repeat (len)
		{
			arr.write(s8, read_byte());
		}
		
		return arr;
	}
	
	///@func read_int array()
	static read_int_array = function ()
	{
		gml_pragma("forceinline");
		return __read_array_generic(read_int);
	}
	
	///@func read_long_array()
	static read_long_array = function ()
	{
		gml_pragma("forceinline");
		return __read_array_generic(read_long);
	}
	
	///@func read_any
	///@param tag_type
	static read_any = function (type)
	{
		switch (type)
		{
			case NbtTag.Byte:       return read_byte();
			case NbtTag.Short:      return read_short();
			case NbtTag.Int:        return read_int();
			case NbtTag.Long:       return read_long();
			case NbtTag.Float:      return read_float();
			case NbtTag.Double:     return read_double();
			case NbtTag.Byte_Array: return read_byte_array();
			case NbtTag.String:     return read_string();
			case NbtTag.List:       return read_list();
			case NbtTag.Compound:   return read_compound();
			case NbtTag.Int_Array:  return read_int_array();
			case NbtTag.Long_Array: return read_long_array();
		}
		
		throw ("Invalid nbt read type "+tostr(type)+"!");
	}
	
	#endregion ------
	#endregion ------
end
