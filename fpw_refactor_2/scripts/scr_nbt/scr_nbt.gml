#macro nbt_host_endian -1
#macro nbt_big_endian 0
#macro nbt_little_endian 1

#macro nbt_tag_id_none -1
#macro nbt_tag_id_end 0
#macro nbt_tag_id_byte 1
#macro nbt_tag_id_short 2
#macro nbt_tag_id_int 3
#macro nbt_tag_id_long 4
#macro nbt_tag_id_float 5
#macro nbt_tag_id_double 6
#macro nbt_tag_id_byte_array 7
#macro nbt_tag_id_string 8
#macro nbt_tag_id_list 9
#macro nbt_tag_id_compound 10
#macro nbt_tag_id_int_array 11
#macro nbt_tag_id_long_array 12
#macro nbt_tag_id_invalid 13

#region util funcx
function nbt_tag_type_name (_tag_id)
{
	switch (_tag_id)
	{
		case nbt_tag_id_end:
			return "TAG_End";
			
		case nbt_tag_id_byte:
			return "TAG_Byte";
			
		case nbt_tag_id_short:
			return "TAG_Short";
		
		case nbt_tag_id_int:
			return "TAG_Int";
		
		case nbt_tag_id_long:
			return "TAG_Long";
		
		case nbt_tag_id_float:
			return "TAG_Float";
		
		case nbt_tag_id_double:
			return "TAG_Double";
		
		case nbt_tag_id_byte_array:
			return "TAG_Byte_Array";
		
		case nbt_tag_id_string:
			return "TAG_String";
		
		case nbt_tag_id_list:
			return "TAG_List";
		
		case nbt_tag_id_compound:
			return "TAG_Compound";
			
		case nbt_tag_id_int_array:
			return "TAG_Int_Array";
		
		case nbt_tag_id_long_array:
			return "TAG_Long_Array";
		
		default:
			return "Invalid tag";
	}
}

// reminder to self, java and MC:JE are big endian.
// GM is little endian (apparently). eugh

function nbt_buffer_read_string (_f, _func)
{
	// we use the internal wrapper function
	// to read the length, but not the string
	// or the temporary terminator
	// this is because those arent affected by
	// endianness. the wrapper's only really
	// there because of the endian bullshit
	// and so it can be changed to work with
	// the file_bin_* functions
	var len = _func(_f, buffer_u16);
	var tell = buffer_tell(_f);
		
	if (tell + len >= buffer_get_size(_f))
	{
		return buffer_read(_f, buffer_text);
	}
		
	var temp = buffer_peek(_f, tell + len, buffer_u8);
	buffer_poke(_f, tell + len, buffer_u8, 0);
		
	var s = buffer_peek(_f, tell, buffer_string);
		
	buffer_poke(_f, tell + len, buffer_u8, temp);
	buffer_seek(_f, buffer_seek_relative, len);
		
	return s;
}

function nbt_buffer_read_le (_f, _type)
{
	if (_type == buffer_string or _type == buffer_text)
	{
		return nbt_buffer_read_string(_f, buffer_read);
	}
		
	return buffer_read(_f, _type);
}

function nbt_buffer_read_be (_f, _type)
{
	// im lazy.
	if (_type == buffer_string or _type == buffer_text)
	{
		return nbt_buffer_read_string(_f, nbt_buffer_read_be);
	}
		
	var itm_sz = buffer_sizeof(_type) - 1;
		
	// fuck it we're reading a byte anyway
	// dont need to do any of this shit
	if (itm_sz == 0)
	{
		return buffer_read(_f, _type);
	}
		
	// swap the bytes in-place in the buffer,
	// halfway through read the value,
	// then continue swapping anyway, as this
	// reverses the data back to what it was.
	// this way we dont have to create and destroy
	// a buffer specifically for the value
	var sz_rd = itm_sz - (itm_sz >> 1);
	var outv;
	var t = buffer_tell(_f);
	
	for (var i = itm_sz; i >= 0; i--)
	{
		var swap_ofs = t + (itm_sz - i);
		var ofs = t + i;
		var swap = buffer_peek(_f, swap_ofs, u8);
			
		buffer_poke(_f, swap_ofs, u8, buffer_peek(_f, ofs, u8));
		buffer_poke(_f, ofs, u8, swap);
			
		if (i == sz_rd)
		{
			outv = buffer_read(_f, _type);
		}
	}
		
	return outv;
}

#endregion

#region tag objects
///@func Nbt_tag
///@arg tag_type
///@arg [tag_name]
function Nbt_tag (_type, _name) constructor begin
	static name    = function () { return __name }
	static type    = function () { return __tag_type }
	static destroy = function () { ; }
	static length  = function () { return __length }
	static value   = function () { return __value }
	static set     = function (_value) { __value = _value; }
	static deserialize = -1;
	static serialize = -1;
	
	__name = is_undefined(_name) ? "" : _name;
	__length = 0;
	__tag_type = _type;
	__value = -1;
	
	static __serialize_generic = function (_writer)
	{
		_writer.write(buffer_s8, __tag_type);
		_writer.write(buffer_s16, string_length(__name));
		_writer.write(buffer_text, __name)
	}
	
	static to_struct = function ()
	{
		return [__name, __value];
	}
	
	static __name_to_string = function ()
	{
		if (__name == "")
		{
			return "";
		}
		
		return __name + ": ";
	}
end

#region basic types tags
///@func Nbt_tag_byte
///@desc A buffer_s8 value
///@arg value
///@arg [tag_name]
function Nbt_tag_byte (_value, _name)  : Nbt_tag(nbt_tag_id_byte, _name) constructor begin
	static __length = buffer_sizeof(buffer_s8);
	
	static set = function (_value)
	{
		__value = floor(_value);
	}
	
	static serialize = function (_writer)
	{
		_writer.write(buffer_s8, __value);
	}
	
	static deserialize = function (_reader)
	{
		set(_reader.read(buffer_s8));
		return self;
	}
	
	static toString = function ()
	{
		return __name_to_string()+string(__value) + "B";
	}
	
	set(_value);
end


///@func Nbt_tag_short
///@desc A buffer_s16 value
///@arg value
///@arg [tag_name]
function Nbt_tag_short (_value, _name) : Nbt_tag(nbt_tag_id_short, _name) constructor begin
	static __length = buffer_sizeof(buffer_s16);
	
	static serialize = function (_writer)
	{
		_writer.write(buffer_s16, __value);
	}
	
	static deserialize = function (_reader)
	{
		set(_reader.read(buffer_s16));
		return self;
	}
	
	static set = function (_value)
	{
		__value = floor(_value);
	}
	
	static toString = function ()
	{
		return __name_to_string()+string(__value) + "S";
	}
	
	set(_value);
end


///@func Nbt_tag_int
///@desc A buffer_s32 value
///@arg value
///@arg [tag_name]
function Nbt_tag_int (_value, _name) : Nbt_tag(nbt_tag_id_int, _name) constructor begin
	static __length = buffer_sizeof(buffer_s32);
	
	static serialize = function (_writer)
	{
		_writer.write(buffer_s32, __value);
	}
	
	static deserialize = function (_reader)
	{
		set(_reader.read(buffer_s32));
		return self;
	}
	
	static set = function (_value)
	{
		__value = floor(_value);
	}
	
	static toString = function ()
	{
		return __name_to_string()+string(__value);
	}
	
	set(_value);
end


///@func Nbt_tag_long
///@desc A buffer_s64 value
///@arg value
///@arg [tag_name]
function Nbt_tag_long (_value, _name) : Nbt_tag(nbt_tag_id_long, _name) constructor begin
	static __length = buffer_sizeof(buffer_u64);
	
	static serialize = function (_writer)
	{
		_writer.write(buffer_u64, __value);
	}
	
	static deserialize = function (_reader)
	{
		set(_reader.read(buffer_u64));
		return self;
	}
	
	static set = function (_value)
	{
		__value = floor(_value);
	}
	
	static toString = function ()
	{
		return __name_to_string()+string(__value) + "L";
	}
	
	set(_value);
end


///@func Nbt_tag_float
///@desc A buffer_f32 value
///@arg value
///@arg [tag_name]
function Nbt_tag_float (_value, _name) : Nbt_tag(nbt_tag_id_float, _name) constructor begin
	static __length = buffer_sizeof(buffer_f32);
	
	static serialize = function (_writer)
	{
		_writer.write(buffer_f32, __value);
	}
	
	static deserialize = function (_reader)
	{
		set(_reader.read(buffer_f32));
		return self;
	}
	
	static toString = function ()
	{
		return __name_to_string()+string_format(__value, 0, 8) + "F";
	}
	
	set(_value);
end


///@func Nbt_tag_double
///@desc A buffer_f64 value
///@arg value
///@arg [tag_name]
function Nbt_tag_double (_value, _name) : Nbt_tag(nbt_tag_id_double, _name) constructor begin
	static __length = buffer_sizeof(buffer_f64);
	
	static serialize = function (_writer)
	{
		_writer.write(buffer_f64, __value);
	}
	
	static deserialize = function (_reader)
	{
		set(_reader.read(buffer_f64));
		return self;
	}
	
	static toString = function ()
	{
		return __name_to_string()+string_format(__value, 0, 8);
	}
	
	set(_value);
end


///@func Nbt_tag_string
///@desc A string. Duh.
///@arg value
///@arg [tag_name]
function Nbt_tag_string (_value, _name) : Nbt_tag(nbt_tag_id_string, _name) constructor begin
	static set = function (_value)
	{
		__value = string(_value);
		__length = string_length(__value);
	}
	
	static serialize = function (_writer)
	{
		_writer.write(buffer_u16, __length);
		_writer.write(buffer_text, __value);
	}
	
	static deserialize = function (_reader)
	{
		///TODO: this shouldnt be dependant on the reader having
		/// a function that reads the strings length for us.
		set(_reader.read(buffer_string));
		return self;
	}
	
	static toString = function ()
	{
		return __name_to_string()+"\""+__value+"\"";
	}
	
	set(_value);
end

#endregion

#region dedicated array type tags
// I could most likely make a boilerplate class extending from Nbt_tag
// for these but whatever it doesnt matter that much since theres only
// three of them.

///@func Nbt_tag_byte_array
///@desc An array of buffer_s8 values
///@arg array
///@arg [tag_name]
function Nbt_tag_byte_array (_array, _name)  : Nbt_tag(nbt_tag_id_byte_array, _name) constructor begin
	static buffer_type = buffer_s8;
	
	static set = function (_array)
	{
		__length = array_length(_array);
		__value = array_create(__length);
		
		for (var i = 0; i < __length; ++i)
		{
			__value[@i] = floor(_array[i]);
		}
	}
	
	static serialize = function (_writer)
	{
		_writer.write(buffer_s32, __length);
		
		for (var i = 0; i < __length; ++i)
		{
			_writer.write(buffer_s8, __value[i]);
		}
		
	}
	
	static deserialize = function (_reader)
	{
		var len = _reader.read(buffer_s32);
		var arr = array_create(len);
				
		for (var i = 0; i < len; ++i)
		{
			arr[@i] = _reader.read(buffer_s8);
		}
				
		set(arr);
		return self;
	}
	
	static length = function () { return __length }
	
	static toString = function ()
	{
		var s = "[B; ";
		for (var i = 0; i < __length; ++i)
		{
			s += string(__value[i]) + ", ";
		}
		return __name_to_string()+string_delete(s, string_length(s) - 1, 2) + " ]";
	}
	
	if (is_array(_array))
	{
		set(_array);
	}
end


///@func Nbt_tag_int_array
///@desc An array of buffer_s32 values
///@arg array
///@arg [tag_name]
function Nbt_tag_int_array (_array, _name)  : Nbt_tag(nbt_tag_id_int_array, _name) constructor begin
	static buffer_type = buffer_s32;
	
	static set = function (_array)
	{
		__length = array_length(_array);
		__value = array_create(__length);
		
		for (var i = 0; i < __length; ++i)
		{
			__value[@i] = floor(_array[i]);
		}
	}
	
	static serialize = function (_writer)
	{
		_writer.write(buffer_s32, __length);
		
		for (var i = 0; i < __length; ++i)
		{
			_writer.write(buffer_s32, __value[i]);
		}
		
	}
	
	static deserialize = function (_reader)
	{
		var len = _reader.read(buffer_s32);
		var arr = array_create(len);
				
		for (var i = 0; i < len; ++i)
		{
			arr[@i] = _reader.read(buffer_u8);
		}
				
		set(arr);
		return self;
	}
	
	static length = function () { return __length }
	
	static toString = function ()
	{
		var s = "[I; ";
		for (var i = 0; i < __length; ++i)
		{
			s += string(__value[i]) + ", ";
		}
		return __name_to_string()+string_delete(s, string_length(s) - 1, 2) + " ]";
	}
	
	if (is_array(_array))
	{
		set(_array);
	}
end


///@func Nbt_tag_long_array
///@desc An array of buffer_64 values
///@arg array
///@arg [tag_name]
function Nbt_tag_long_array (_array, _name)  : Nbt_tag(nbt_tag_id_long_array, _name) constructor begin
	static buffer_type = buffer_u64;
	
	static set = function (_array)
	{
		__length = array_length(_array);
		__value = array_create(__length);
		
		for (var i = 0; i < __length; ++i)
		{
			__value[@i] = floor(_array[i]);
		}
	}
	
	static serialize = function (_writer)
	{
		_writer.write(buffer_s32, __length);
		
		for (var i = 0; i < __length; ++i)
		{
			_writer.write(buffer_u64, __value[i]);
		}
		
	}
	
	static deserialize = function (_reader)
	{
		var len = _reader.read(buffer_s32);
		var arr = array_create(len);
				
		for (var i = 0; i < len; ++i)
		{
			arr[@i] = _reader.read(buffer_u8);
		}
				
		set(arr);
		return self;
	}
	
	static length = function () { return __length }
	
	static toString = function ()
	{
		var s = "[I; ";
		for (var i = 0; i < __length; ++i)
		{
			s += string(__value[i]) + ", ";
		}
		return __name_to_string()+string_delete(s, string_length(s) - 1, 2) + " ]";
	}
	
	if (is_array(_array))
	{
		set(_array);
	}
end


#endregion

#region structure tags
///@func Nbt_tag_list
///@desc An array of one type of tag
///@arg list_tag_type
///@arg [tag_name]
function Nbt_tag_list (_list_type, _name) : Nbt_tag(nbt_tag_id_list, _name) constructor begin
	__list_type = _list_type;
	__list = [];
	__length = 0;
	
	static serialize = function (_writer)
	{
		__length = length();
		_writer.write(buffer_u8, __list_type);
		_writer.write(buffer_s32, __length);
		
		for (var i = 0; i < __length; ++i)
		{
			var t = __list[i];
			t.serialize(_writer);
		}
		
	}
	
	static deserialize = function (_reader)
	{
		__list_type = _reader.read(buffer_u8);
		var len = _reader.read(buffer_s32);
				
		repeat (len)
		{
			push(_reader.read_tag(__list_type));
		}
				
		return self;
	}
	
	static value = function ()
	{
		return __list;
	}
	
	static get = function (_i)
	{
		return __list[_i];
	}
	
	static push = function (_tag)
	{
		if (is_string(_tag) and __list_type == nbt_tag_id_string)
		{
			__list[@ __length] = new Nbt_tag_string(_tag);
			++__length;
			return self;
		}
		
		if (is_struct(_tag) and _tag.type() == __list_type)
		{
			__list[@ __length] = _tag;
			++__length;
			return self;
		}
		
		show_debug_message(
			"Incorrect tag type, expected "+
			nbt_tag_type_name(__list_type)+
			", got "+nbt_tag_type_name(_tag.type())+". Ignoring."
		);
	}
	
	static to_struct = function ()
	{
		var _map = [];
		for (var i = 0; i < __length; i++)
		{
			var v = __list[i];
			v = v.to_struct();
			_map[@i] = v[1];
		}
		
		return [__name, _map];
	}
	
	static length = function ()
	{
		return array_length(__list);
	}
	
	static list_type = function ()
	{
		return __list_type;
	}
	
	static destroy = function ()
	{
		for (var i = 0; i < __length; ++i)
		{
			var e = __list[i];
			e.destroy();
		}
	}
	
	static toString = function ()
	{
		var s = "[ ";
		for (var i = 0; i < __length; ++i)
		{
			s += string(__list[i]) + ", ";
		}
		return __name_to_string()+string_delete(s, string_length(s) - 1, 2) + " ]";
	}
	
end


///@func Nbt_tag_compound
///@desc A tag of tags
///@arg [tag_name]
function Nbt_tag_compound (_name)  : Nbt_tag(nbt_tag_id_compound, _name) constructor begin
	__data = {};
	__length = 0;
	
	static value = function ()
	{
		return __data;
	}
	
	static serialize = function (_writer)
	{
		var keys = variable_struct_get_names(__data);
		var len = variable_struct_names_count(__data);
		
		for (var i = 0; i < len; i++)
		{
			var m = __data[$keys[i]];
			m.__serialize_generic(_writer);
			m.serialize(_writer);
		}
		
		_writer.write(buffer_u8, nbt_tag_id_end);
	}
	
	static deserialize = function (_reader)
	{
		while (1)
		{
			var new_tag = _reader.read_tag();
					
			if (new_tag <= nbt_tag_id_end)
			{
				break;
			}
					
			add(new_tag);
		}
				
		return self;
	}
	
	static get = function (_name)
	{
		if (!variable_struct_exists(__data, _name))
		{
			return -1;
		}
		
		return __data[?_name];
	}
	
	static add = function (_tag)
	{
		var nomenae = _tag.name();
		
		if (variable_struct_exists(__data, nomenae))
		{
			var tt = get(nomenae);
			tt.destroy();
			delete tt;
			--__length;
		}
		
		__data[$ nomenae] = _tag;
		++__length;
		return _tag;
	}
	
	static length = function ()
	{
		return __length;
	}
	
	static to_struct = function ()
	{
		var _map = {};
		var keys = variable_struct_get_names(__data);
		var len = variable_struct_names_count(__data);
		
		for (var i = 0; i < len; i++)
		{
			var m = __data[$keys[i]].to_struct();
			_map[$ m[0]] = m[1];
		}
		
		return [__name, _map];
	}
	
	static destroy = function ()
	{
		for (var i = 0, len = __length; i < len; ++i)
		{
			var keys = variable_struct_get_names(__data);
			var len = variable_struct_names_count(__data);
			for (var i = 0; i < len; ++i)
			{
				__data[$keys[i]].destroy();
			}
		}
		delete __data;
	}
	
	static toString = function ()
	{
		var s = "[ ";
		var keys = variable_struct_get_names(__data);
		var len = variable_struct_names_count(__data);
		for (var i = 0, len = array_length(keys); i < len; ++i)
		{
			s += string(__data[$keys[i]]) + ", ";
		}
		return __name_to_string()+string_delete(s, string_length(s) - 1, 2) + " ]";
	}
	
end


#endregion

#endregion

function Nbt_buffer_reader () constructor begin
	static set_endianness = function (_endian)
	{
		switch (_endian)
		{
			case nbt_host_endian:
				set_endianness(nbt_little_endian);
				return;
				break;
			default:
			case nbt_big_endian:
				__read = nbt_buffer_read_be;
				break;
			case nbt_little_endian:
				__read = nbt_buffer_read_le;
				break;
		}
		
		__read = method(self, __read);
		__endian = _endian;
	}
	
	static from_buffer = function (_f)
	{
		__f = _f;
		
		var data = read_tag();
		
		return data;
	}
	
	static load_file = function (_path)
	{
		var t__f = buffer_load(_path);
		
		if (t__f == -1)
		{
			throw (_path +" doesnt exist");
		}
		
		if (buffer_peek(t__f, 0, buffer_u8) == $78)
		{
			var b = buffer_decompress(t__f);
			var bsz = buffer_get_size(b);
			buffer_resize(t__f, bsz);
			buffer_copy(b, 0, bsz, t__f, 0);
			buffer_delete(b);
			buffer_seek(t__f, buffer_seek_start, 0);
		}
		
		var data = from_buffer(t__f);
		
		buffer_delete(t__f);
		
		return data;
	}
	
	static read = function (_type)
	{
		return __read(__f, _type);
	}
	
	static read_tag = function (_type)
	{
		var tag = nbt_tag_id_none;
		var name = "";
		
		if (is_undefined(_type))
		{
			_type = read(buffer_u8);
			
			if (_type != nbt_tag_id_end)
			{
				name  = read(buffer_string);
			}
		}
		
		switch (_type)
		{
			case nbt_tag_id_byte:   { tag = new Nbt_tag_byte(0, name); } break;
			
			case nbt_tag_id_short:  { tag = new Nbt_tag_short(0, name); } break;
			
			case nbt_tag_id_int:    { tag = new Nbt_tag_int(0, name); } break;
			
			case nbt_tag_id_long:   { tag = new Nbt_tag_long(0, name); } break;
			
			case nbt_tag_id_float:  { tag = new Nbt_tag_float(0, name); } break;
			
			case nbt_tag_id_double: { tag = new Nbt_tag_double(0, name); } break;
			
			case nbt_tag_id_string: { tag = new Nbt_tag_string(0, name); } break;
			
			case nbt_tag_id_byte_array: { tag = new Nbt_tag_byte_array(-1, name); } break;
			
			case nbt_tag_id_int_array: { tag = new Nbt_tag_int_array(-1, name); } break;
			
			case nbt_tag_id_long_array: { tag = new Nbt_tag_long_array(-1, name); } break;
			
			case nbt_tag_id_list: { tag = new Nbt_tag_list(nbt_tag_id_none, name); } break;
			
			case nbt_tag_id_compound: { tag = new Nbt_tag_compound(name); } break;
			
			case nbt_tag_id_end: break;
			
		}
		
		if (_type > nbt_tag_id_end and _type < nbt_tag_id_invalid)
		{
			tag = tag.deserialize(self);
		}
		
		return tag;
	}
	
	__f = -1;
	__endian = -1;
	__read = -1;
	set_endianness(nbt_big_endian);
	
end


