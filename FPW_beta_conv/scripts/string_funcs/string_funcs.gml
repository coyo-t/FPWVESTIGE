///@arg string
function string_split (str) begin
	var parts = [];

	var tmpStr = "";
	for (var i = 0; i < string_length(str); i++)
	{
		var char = string_char_at(str, i + 1);
	
		if (char == " ")
		{
			parts[array_length(parts)] = tmpStr;
			tmpStr = "";
		} else {
			tmpStr += char;
		
		}
	
	}

	if (tmpStr != "")
	{
		parts[array_length(parts)] = tmpStr;
	}

	return parts;

end


///////////////////oh my god figure out some way to reuse the above thing .-.
///@arg string
///@arg delm
function string_split_ext (argument0, argument1) begin
	var s = argument0;
	var parts = [];

	var tmpStr = "";
	for (var i = 0; i < string_length(s); i++)
	{
		var char = string_char_at(s, i + 1);
	
		if (char == " " || char == argument1)
		{
			parts[array_length(parts)] = tmpStr;
			tmpStr = "";
		} else {
			tmpStr += char;
		
		}
	
	}

	if (tmpStr != "")
	{
		parts[array_length(parts)] = tmpStr;
	}

	return parts;

end


///@arg string
///@arg delm
function string_split_ext_real (argument0, argument1) begin
	var s = argument0;
	var parts = [];

	var tmpStr = "";
	for (var i = 0; i < string_length(s); i++)
	{
		var char = string_char_at(s, i + 1);
	
		if (char == " " || char == argument1)
		{
			parts[array_length(parts)] = real(tmpStr);
			tmpStr = "";
		} else {
			tmpStr += char;
		
		}
	
	}

	if (tmpStr != "")
	{
		parts[array_length(parts)] = tmpStr;
	}

	return parts;

end


///@arg path
function file_text_open_string (argument0) begin
	if (file_exists(argument0))
	{
		var str = -1;
		var bff = buffer_load(argument0);
		str = buffer_read(bff, buffer_text);
		buffer_delete(bff);
		string_replace_all(str, "\r", "");
		//var _f = file_text_open_read(argument0);
		//var str = "";
	
		//while (!file_text_eof(_f))
		//{
		//	str += file_text_readln(_f);
		//}
		//file_text_close(_f);
		return str;
	} else {
		return -1;
	}

end
