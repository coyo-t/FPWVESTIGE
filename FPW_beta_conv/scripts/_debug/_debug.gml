// debug macros
_G.debug = true;

#macro DEBUG         _G.debug
#macro release:DEBUG false

#macro DEBUG_SHOW_FPS             (false && DEBUG)
#macro DEBUG_SHOW_CHAR_ICONS      (false && DEBUG)
#macro DEBUG_FILES_NO_OBFUSCATION (true && DEBUG)

///@arg string
///@arg value
function debug_push_string (str, val) begin
	var oName = !is_undefined(object_index)
		? "[" + object_get_name(object_index) + "] "
		: "";

	ds_stack_push(
		_G.debug_text_stack,
		oName + string(str) + ": " + string(val) + "\n"
	);

end
