///@func Buffer
///@arg size
///@arg type
///@arg alignment
function Buffer (_sz, _type, _alignment) constructor begin
	__buffer = buffer_create(_sz, _type, _alignment);
	
	///@func free()
	static free = function ()
	{
		buffer_delete(__buffer);
	}
	
	///@func read(type)
	static read = function (_type)
	{
		return buffer_read(__buffer, _type);
	}
	
	///@func read_be(type)
	static read_be = function (_type)
	{
		// swap the bytes in-place in the buffer,
		// halfway through read the value,
		// then continue swapping anyway, as this
		// reverses the data back to what it was.
		// this way we dont have to create and destroy
		// a buffer specifically for the value
		var itm_sz = sizeof(_type) - 1;
		var sz_rd = itm_sz - (itm_sz >> 1);
		var outv;
		var t = buffer_tell(__buffer);
		
		for (var i = itm_sz; i >= 0; i--)
		{
			var swap_ofs = t + (itm_sz - i);
			var swap = buffer_peek(__buffer, swap_ofs, u8);
			
			buffer_poke(__buffer, swap_ofs, u8, buffer_peek(__buffer, t + i, u8));
			buffer_poke(__buffer, t + i, u8, swap);
			
			if (i == sz_rd)
			{
				outv = buffer_read(__buffer, _type);
			}
		}
		
		return outv;
	}
	
	///@func strcpy(ofs, len)
	static strcpy = function (ofs, len)
	{
		// temp store the byte after the string's length
		// and set it to null, read the string, then set
		// the byte back to what it was. unless it goes
		// outside the buffer's length, in which case we
		// can just use the read text func to get chars
		// up to the end.
		// this saves us from having to make and destroy
		// a temp buffer for the string.
		var t = buffer_tell(__buffer);
		
		if (ofs + len >= buffer_size(__buffer))
		{
			return buffer_peek(__buffer, ofs, text_t);
		}
		
		var tmp = buffer_peek(__buffer, ofs + len, u8);
		buffer_poke(__buffer, ofs + len, u8, 0);
		
		var outs = buffer_peek(__buffer, t, string_t);
		buffer_poke(__buffer, ofs + len, u8, tmp);
		
		return outs;
	}
	
	///@func write
	///@param type
	///@param value
	static write = function (_type, _val)
	{
		buffer_write(__buffer, _type, _val);
		return self;
	}
	
	///@func write_buffer
	///@arg buffer
	static write_buffer = function (_bff)
	{
		var t = buffer_tell(__buffer);
		var src_bff = _bff;
		
		if (is_struct(_bff) and instanceof(_bff) == "Buffer")
		{
			src_bff = _bff.get_buffer();
		}
		
		var src_sz = min(buffer_size(_bff), buffer_size(__buffer) - t);
		
		buffer_copy(src_bff, 0, src_sz, __buffer, t);
		buffer_seek(__buffer, seek_offset, src_sz);
		
		return self;
	}
	
	///@func peek
	///@param offset
	///@param type
	static peek = function (_ofs, _type)
	{
		return buffer_peek(__buffer, _ofs, _type);
	}
	
	///@func poke
	///@param offset
	///@param type
	///@param value
	static poke = function (_ofs, _type, _val)
	{
		buffer_poke(__buffer, _ofs, _type, _val);
		return self;
	}
	
	///@func seek
	///@param base
	///@param offset
	static seek = function (base, offset)
	{
		buffer_seek(__buffer, base, offset);
		return self;
	}
	
	///@func tell()
	static tell = function ()
	{
		return buffer_tell(__buffer);
	}
	
	///@func rewind()
	static rewind = function ()
	{
		buffer_seek(__buffer, seek_set, 0);
		return self;
	}
	
	///@func get_address()
	static get_address = function ()
	{
		return buffer_get_address(__buffer);
	}
	
	///@func get_size()
	static get_size = function ()
	{
		return buffer_size(__buffer);
	}
	
	///@func set_size(new_size)
	static set_size = function (new_size)
	{
		buffer_resize(__buffer, new_size);
		return self;
	}
	
	///@func resize_to_tell()
	static resize_to_tell = function ()
	{
		buffer_resize(__buffer, buffer_tell(__buffer));
		return self;
	}
	
	///@func get_type()
	static get_type = function ()
	{
		return buffer_get_type(__buffer);
	}
	
	///@func set_type(new_type)
	static set_type = function (_type)
	{
		if (_type == get_type())
		{
			return;
		}
		
		var sz = buffer_size(__buffer);
		var b = buffer_create(sz, _type, alignment());
		var t = buffer_tell(__buffer);
		
		buffer_copy(__buffer, 0, sz, b, 0);
		buffer_delete(__buffer);
		__buffer = b;
		buffer_seek(__buffer, seek_set, t);
	}
	
	///@func get_alignment()
	static get_alignment = function ()
	{
		return buffer_get_alignment(__buffer);
	}
	
	///@func set_alignment(new_alignment)
	static set_alignment = function (_align)
	{
		if (_align == get_alignment())
		{
			return;
		}
		
		var sz = buffer_size(__buffer);
		var b = buffer_create(sz, get_type(), _align);
		var t = buffer_tell(__buffer);
		
		buffer_copy(__buffer, 0, sz, b, 0);
		buffer_delete(__buffer);
		__buffer = b;
		buffer_seek(__buffer, seek_set, t);
	}
	
	///@func get_buffer()
	static get_buffer = function ()
	{
		return __buffer;
	}
	
	///@func set_buffer(buffer)
	static set_buffer = function (b)
	{
		if (is_struct(b) and instanceof(b) == "Buffer")
		{
			b = b.get_buffer();
		}
		
		var t = buffer_tell(__buffer);
		buffer_delete(__buffer);
		__buffer = b;
		buffer_seek(__buffer, seek_set, t);
	}
end
