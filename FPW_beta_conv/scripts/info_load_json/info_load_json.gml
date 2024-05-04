///@arg file
function info_load_json(argument0) {

	return json_decode(file_text_open_string(BASEPATH + argument0));
	if (DEBUG_FILES_NO_OBFUSCATION)
	{
		//return json_decode(file_text_open_string(BASEPATH + argument0));
	}



}
