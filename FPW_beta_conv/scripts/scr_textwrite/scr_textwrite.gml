function textwrite_load_bfont (path) begin
	var bfont_path = "sprfonts/";
	var bfont_info = info_load_json(bfont_path + path);
	
	begin
		var spr_asset = -1;
		var spr_key = "sprite";
		
		if (ds_map_exists(bfont_info, spr_key))
			spr_asset = asset_get_index(bfont_info[?spr_key]);
	
		spr_asset = (spr_asset == -1)
			? __spr_missing_wh
			: spr_asset;
		
		bfont_info[?spr_key] = spr_asset;
	end
	
	return bfont_info;
end


function textwrite_make_sequence (text, commands) begin
	static is_cmd_char = function (_chr, _cmdchrs) begin
		return ds_map_exists(_cmdchrs, _chr);
	end
	
	var wstr = "";
	var char = "";
	var str_len = string_length(text);
	var out_seq = [];
	
	var first_char = string_char_at(text, 1);
	var is_cmd = is_cmd_char(first_char, commands);
	var curr_cmd = is_cmd ? first_char : "";
	var i = 0;
	i += is_cmd ? 1 : 0;
	
	// thought: start i at 1? most of the times i use it its based around 1 indexing because string soo?
	for (; i < str_len; i++)
	{
		char = string_char_at(text, i+1);
		var char_is_cmd = (!is_cmd && is_cmd_char(char, commands)) || (is_cmd && char == curr_cmd);
		var is_end = (i == (str_len - 1));
		
		if (char_is_cmd || is_end)
		{
			var next = string_char_at(text, i+2);
			var is_next_cmd = is_cmd_char(next, commands);
			
			if (!is_cmd && !is_end)
				curr_cmd = char;
			
			if (is_end && !is_cmd)
				wstr += char;
			
			if ((!is_next_cmd && !is_cmd) || is_cmd)
			{
				if (is_cmd)
				{
					array_push(out_seq, commands[?char]);
					array_push(out_seq, wstr);
				} else
					if (string_length(wstr) != 0)
						for (var j = 1; j <= string_length(wstr);)
							array_push(out_seq, string_char_at(wstr, j++));

				
				wstr = "";
				is_cmd ^= true;
				continue;
				
			} else i++;
			
		}
		
		wstr += char;
	}
	
	return out_seq;
	
end
