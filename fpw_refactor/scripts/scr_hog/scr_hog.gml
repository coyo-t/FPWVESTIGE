// Hoggers.

enum HogFlags {       // these flags apply to everything after the header
	compressed     = 1, // is Zlib'd
	encrypted      = 2, // xor'd with "HOGCHAMP"
	reversed_bytes = 4, // bits of each byte are reversed
};


enum FileFlags {
	compressed     = 1, // uses zlib compression
	encrypted      = 2, // is xor'd with "HOGCHAMP"
	reversed_bytes = 4, // the bits of all bytes are reversed
	is_text_file   = 8, // the file is a text file
};


#region utility funcs
function flip_byte (byte)
{
	return (
		((byte << 7) & $80) |
		((byte << 5) & $40) |
		((byte << 3) & $20) |
		((byte << 1) & $10) |
		((byte >> 1) & $08) |
		((byte >> 3) & $04) |
		((byte >> 5) & $02) |
		((byte >> 7) & $01)
	);
}


function decompress_data (bff)
{
	var unzip = buffer_decompress(bff);
	var unzipsize = buffer_get_size(unzip);
	
	buffer_resize(bff, unzipsize);
	
	buffer_copy(unzip, 0, unzipsize, bff, 0);
	
	buffer_delete(unzip);
	
	buffer_seek(bff, buffer_seek_start, 0);
	
}


function flip_data (bff)
{
	var size = buffer_get_size(bff);
	buffer_seek(bff, buffer_seek_start, 0);
	
	repeat (size)
	{
		var byte = buffer_peek(bff, buffer_tell(bff), buffer_u8);
		byte = flip_byte(byte);
		
		buffer_write(bff, buffer_u8, byte);

	}
}


function cypher_data (bff)
{
	static key = "HOGCHAMP";
	static key_len = string_byte_length(key);
	
	var size = buffer_get_size(bff);
	buffer_seek(bff, buffer_seek_start, 0);
	
	repeat (size)
	{
		var tell = buffer_tell(bff);
		var byte = buffer_peek(bff, tell, buffer_u8);
		
		byte ^= string_byte_at(key, (tell % key_len) + 1);
		
		buffer_write(bff, buffer_u8, byte);
	}
}


#endregion

function HogChampFile (hog_buffer, _nametable) constructor begin
	data = hog_buffer;
	nametable = _nametable;
	
	static get_file = function (_name)
	{
		if (!ds_map_exists(nametable, _name))
			return -1;
		
		var nt_entry = nametable[? _name];
		
		var bff = buffer_create(nt_entry[1], buffer_fixed, 1);
		buffer_copy(data, nt_entry[0], nt_entry[1], bff, 0);
		
		buffer_seek(bff, buffer_seek_start, 0);
		
		if (nt_entry[2])
		{
			var s = buffer_read(bff, text_t);
			buffer_delete(bff);
			return s;
		}
		
		return bff;
		
	}
	
	static free = function ()
	{
		buffer_delete(data);
		ds_map_destroy(nametable);
	}
	
end

function file_hog_load (path)
{
	path = BASEPATH + path;
	
	if (!file_exists(path))
	{
		sdm("hog: file doesnt exist");
		return -1;
	}
	
	var hog = buffer_load(path);
	
	return hog_load(hog);
	
}

function hog_load (hog)
{
	static HEADER_MAGIC = $43474F48;
	static CUR_HOG_VR   = 2;
	
	if (buffer_read(hog, buffer_u32) != HEADER_MAGIC)
	{
		sdm("hog: not a piggy");
		buffer_delete(hog);
		return -1;
	}
	
	// okay yeah this is probably a hog file
	
	var version     = buffer_read(hog, buffer_u16); // should probably abort if the version isnt what we supp. but w/e.
	var flags       = buffer_read(hog, buffer_u32);
	var header_size = buffer_read(hog, buffer_u16);
	
	var nt_addr     = buffer_read(hog, buffer_u32);
	var nt_size     = buffer_read(hog, buffer_u32);
	
	var data_addr   = buffer_read(hog, buffer_u32);
	var data_size   = buffer_read(hog, buffer_u32);
	
	var thing_count = buffer_read(hog, buffer_u32);
	
	// apply any operations according to the flags
	// the order here is reversed, encrypted, compressed
	// i copy the header to its own thing here because im not sure if buffer_resize
	// clears the buffer in a similar manor to surface_resize
	// this probably makes it wildly less efficent than it could be :sadbeale:
	{
		var d = buffer_create(buffer_get_size(hog) - header_size, buffer_fixed, 1);
		buffer_copy(hog, header_size, buffer_get_size(hog) - header_size, d, 0);
	
		//var h = buffer_create(header_size, buffer_fixed, 1);
		//buffer_copy(hog, 0, header_size, h, 0);
	
		if (flags & HogFlags.reversed_bytes)
			flip_data(d);
		
		if (flags & HogFlags.encrypted)
			cypher_data(d);
		
		if (flags & HogFlags.compressed)
			decompress_data(d);
		
		var newsize = buffer_get_size(d);
		buffer_resize(hog, header_size + newsize);
		//buffer_copy(h, 0, header_size, hog, 0);
		buffer_copy(d, 0, newsize, hog, header_size);
		
		//buffer_delete(h);
		buffer_delete(d);
		
	}
	
	// now get all the data out
	var files = buffer_create(1, buffer_fixed, 1);
	var file_nt = ds_map_create();
	
	buffer_seek(hog, buffer_seek_start, nt_addr);
	
	var size_accum = 0;
	repeat (thing_count)
	{
		var curr_addr = buffer_tell(hog);
		
		var f_addr_rel     = buffer_read(hog, buffer_u32);
		var f_addr     = f_addr_rel + data_addr;
		var f_size     = buffer_read(hog, buffer_u32);
		var f_flags    = buffer_read(hog, buffer_u32);
		var f_adler32  = buffer_read(hog, buffer_u32);
		var f_name     = buffer_read(hog, buffer_string);
		
		var d = buffer_create(f_size, buffer_fixed, 1);
		buffer_copy(hog, f_addr, f_size, d, 0);
		
		if (f_flags & FileFlags.reversed_bytes)
			flip_data(d);
		
		if (f_flags & FileFlags.encrypted)
			cypher_data(d);
		
		if (f_flags & FileFlags.compressed)
			decompress_data(d);
		
		//if (f_flags & FileFlags.is_text_file)
		//{
		//	buffer_seek(d, buffer_seek_start, 0);
		//	var text = buffer_read(d, buffer_text);
			
		//	buffer_delete(d);
			
		//	d = text;
		//}
		
		var dsize = buffer_get_size(d);
		buffer_resize(files, buffer_get_size(files) + dsize);
		buffer_copy(d, 0, dsize, files, size_accum);
		size_accum += dsize;
		
		file_nt[? f_name] = [f_addr_rel, dsize, f_flags & FileFlags.is_text_file];
		
	}
	
	buffer_delete(hog);
	
	return new HogChampFile(files, file_nt);
	
}
