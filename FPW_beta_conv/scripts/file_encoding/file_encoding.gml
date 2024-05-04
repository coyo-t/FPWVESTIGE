///@arg string
///@arg path
function string_cc_save (in_str, path) begin
	//var path = temp_directory + SAVE_NAME;	
	//var savestr = base64_encode(json_encode(save_data));
	
	var buffer_out  = buffer_create(64, buffer_grow, 1);
	var buffer_data = buffer_create(64, buffer_grow, 1);
	
	// write the file data, then reverse the bits
	buffer_seek(buffer_data, buffer_seek_start, 0);
	buffer_write(buffer_data, buffer_text, in_str);
	
	buffer_seek(buffer_data, buffer_seek_start, 0);
	repeat (buffer_get_size(buffer_data))
	{
		var byte = buffer_peek(buffer_data, buffer_tell(buffer_data), buffer_u8);
		buffer_write(buffer_data, buffer_u8, byte_flip(byte));
	}
	
	// generate the MD5 hash of the savedata
	var md5_str = buffer_md5(buffer_data, 0, buffer_get_size(buffer_data));
	
	// write all the data to the outgoing buffer
	buffer_seek(buffer_out, buffer_seek_start, 0);
	
	//write the MD5 hash's size then itself
	buffer_write(buffer_out, buffer_u32, string_byte_length(md5_str));
	buffer_write(buffer_out, buffer_text, md5_str);
	
	// write the data's size, then itself
	buffer_write(buffer_out, buffer_u32, buffer_get_size(buffer_data));
	buffer_copy(buffer_data, 0, buffer_get_size(buffer_data), buffer_out, buffer_tell(buffer_out));
	
	// save the data, then cleanup
	buffer_save(buffer_out, path);
	
	buffer_delete(buffer_out);
	buffer_delete(buffer_data);
	

end


///@arg path
function string_cc_load (path) begin
	//var path = temp_directory + SAVE_NAME;

	if (!file_exists(path))
		return -1;
		
	var buffer_in   = buffer_load(path);
	var buffer_data = buffer_create(64, buffer_grow, 1);
	var md5_str_in, md5_str_data;
		
	buffer_seek(buffer_in, buffer_seek_start, 0);
		
	// grab the MD5 hash of the data
	{
		var md5_str_size = buffer_read(buffer_in, buffer_u32);
			
		buffer_copy(buffer_in, buffer_tell(buffer_in), md5_str_size, buffer_data, 0);
		buffer_seek(buffer_in, buffer_seek_relative, md5_str_size);
		
		md5_str_in = buffer_read(buffer_data, buffer_text);
	}
		
	// grab the encoded save data
	{
		var data_size = buffer_read(buffer_in, buffer_u32);
			
		// generate the MD5 hash of the loaded savedata before reversing it
		md5_str_data = buffer_md5(buffer_in, buffer_tell(buffer_in), data_size);
			
		// copy the data
		buffer_copy(buffer_in, buffer_tell(buffer_in), data_size, buffer_data, 0);
			
		// reverse the bits
		buffer_seek(buffer_data, buffer_seek_start, 0);
		repeat (data_size)
		{
			var byte = buffer_peek(buffer_data, buffer_tell(buffer_data), buffer_u8);
			buffer_write(buffer_data, buffer_u8, byte_flip(byte));
		}
			
	}
	
	var out = -1;
	// compare the two hashes and act accordingly
	if (md5_str_data == md5_str_in)
	{
		buffer_seek(buffer_data, buffer_seek_start, 0);
		out = buffer_read(buffer_data, buffer_text);
		
	}
	
	buffer_delete(buffer_data);
	buffer_delete(buffer_in);
	
	return out;

end