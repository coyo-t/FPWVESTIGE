//_G.debug_showCharIcons = false && DEBUG;
//_G.debug_infPower = false && DEBUG;

vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_texcoord();
vertex_format_add_colour();
_G.vform_shadeless = vertex_format_end();
_G.draw_state_stack = ds_stack_create();

_G.draw_model_colour = c_white;
_G.draw_model_alpha  = 1.;
_G.draw_model_sha_uniform = shader_get_uniform(sha_model, "mdl_colour");

function __refresh_model_colour () begin
	shader_set_uniform_f_array(
		_G.draw_model_sha_uniform,
		[
			colour_get_red(_G.draw_model_colour)/255, 
			colour_get_green(_G.draw_model_colour)/255,
			colour_get_blue(_G.draw_model_colour)/255,
			_G.draw_model_alpha
		]
	);
end

///@arg colour
function draw_set_model_colour (argument0) begin
	_G.draw_model_colour = argument0;

	__refresh_model_colour();

end


///@arg alpha
function draw_set_model_alpha (argument0) begin
	_G.draw_model_alpha = argument0;

	__refresh_model_colour();

end

draw_set_model_colour(c_white);
draw_set_model_colour(1.);


///@arg fov_degrees
///@arg width
///@arg height
function fov_h2v (fov, width, height) begin
	return radtodeg(2 * arctan(tan(degtorad(fov) * 0.5) * (height / width)));
end


///@arg fov_degrees
///@arg width
///@arg height
function fov_v2h (fov, width, height) begin
	return radtodeg(2 * arctan(tan(degtorad(fov) * 0.5) * (width / height)));
end


///@arg vbuffer
///@arg posx
///@arg posy
///@arg posz
///@arg texu
///@arg texv
///@arg col
function vertex_add_kms(buff, px, py, pz, u, v, col) begin
	vertex_position_3d(buff, px, py, pz);
	vertex_texcoord(buff, u, 1-v);
	vertex_colour(buff, col, 1.0);
end


///@arg file_path
///@arg vertex_format
///@arg freeze_vbuffer
function model_load_vbm (path, vformat, freeze) begin
	var bff = buffer_load(path);
	var mdl = vertex_create_buffer_from_buffer(bff, vformat);

	buffer_delete(bff);

	if (freeze) vertex_freeze(mdl);

	return mdl;
end


///@arg filename
///@arg vertex_format
function model_load_obj (filename, vformat) begin
	var model = vertex_create_buffer();

	var file = file_text_open_read(filename);
	var _v  = ds_list_create();
	var _vt = ds_list_create();
	var _f  = ds_list_create();
	var _ft = ds_list_create();

	//sigh file time.
	if (file != -1)
	{
		do
		{
			var line_str = file_text_readln(file);
			var line = string_split(line_str);
		
			switch (line[0])
			{
				case "v":
					ds_list_add(_v, [real(line[1]), real(line[2]), real(line[3])]);
					break;
				
				case "vt":
					ds_list_add(_vt, [real(line[1]), real(line[2])]);
					break;
				
				case "f":
					if (array_size(line) - 1 == 3)
					{
						var _s = line[1] + " " + line[2] + " " + line[3];
						_s = string_split_ext_real(_s, "/");
						ds_list_add(_f, [
							real(_s[0]),
							real(_s[2]),
							real(_s[4])
						]);
						ds_list_add(_ft, [
							real(_s[1]),
							real(_s[3]),
							real(_s[5])
						]);
					} else {
						show_error("NO I DONT WANNA BE QUADS NOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO", true);
					}
					break;
			}
		
		} until (file_text_eof(file))
	}

	vertex_begin(model, vformat);

	for (var i = 0; i < ds_list_size(_f); ++i)
	{
		var fInd  = _f[| i];
		var ftInd = _ft[| i];
	
		var v1 = _v[| fInd[0] - 1];
		var v2 = _v[| fInd[1] - 1];
		var v3 = _v[| fInd[2] - 1];
	
		var vt1 = _vt[| ftInd[0] - 1];
		var vt2 = _vt[| ftInd[1] - 1];
		var vt3 = _vt[| ftInd[2] - 1];
	
		vertex_add_kms(model, v1[0], v1[1], v1[2], vt1[0], vt1[1], $FFFFFF);
		vertex_add_kms(model, v2[0], v2[1], v2[2], vt2[0], vt2[1], $FFFFFF);
		vertex_add_kms(model, v3[0], v3[1], v3[2], vt3[0], vt3[1], $FFFFFF);
	
	}

	vertex_end(model);

	ds_list_destroy(_v);
	ds_list_destroy(_vt);
	ds_list_destroy(_f);
	ds_list_destroy(_ft);

	return model;
end
