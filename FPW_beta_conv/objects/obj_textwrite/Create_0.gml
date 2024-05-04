/// @desc
#region vertex shit
char_vbuff = vertex_create_buffer();

///@arg vbuffer
///@arg posx
///@arg posy
///@arg posz
///@arg texu
///@arg texv
///@arg col
///@arg alpha
function add_point (_vbuff, x, y, z, u, v, c, a) begin
	vertex_position_3d(_vbuff, x, y, z);
	vertex_texcoord(_vbuff, u, v);
	vertex_colour(_vbuff, c, a);
end


///@arg vertex_buffer
///@arg top_left
///@arg top_right
///@arg bot_left
///@arg bot_right
///@desc point arrays formatted as [x, y, u, v, col, alpha] 
function create_char_quad (vbuff, tl, tr, bl, br) begin
	//tri 1
	add_point(vbuff, bl[0], bl[1], 0, bl[2], bl[3], bl[4], bl[5]); //p1, bottom left
	add_point(vbuff, tl[0], tl[1], 0, tl[2], tl[3], tl[4], tl[5]); //p4, top left
	add_point(vbuff, tr[0], tr[1], 0, tr[2], tr[3], tr[4], tr[5]); //p3, top right
	
	//tri 2
	add_point(vbuff, bl[0], bl[1], 0, bl[2], bl[3], bl[4], bl[5]); //p1, bottom left
	add_point(vbuff, tr[0], tr[1], 0, tr[2], tr[3], tr[4], tr[5]); //p3, top right
	add_point(vbuff, br[0], br[1], 0, br[2], br[3], br[4], br[5]); //p2, bottom right
	
end

function _cqp (_x, _y, _u, _v, _col, _a) begin
	return [_x, _y, _u, _v, _col, _a];
end


#endregion


enum Textwrite_type {
	cmd_draw = 0,
	cmd_step,
	skip
}

tw_state = {
	point_cols: [c_white, c_white, c_white, c_white], //tl tr bl br
	set_col_mono: function (_col) begin
		self.point_cols = [_col, _col, _col, _col];
	end
}

bfont_info = textwrite_load_bfont("fish.json");
//bfont_info = textwrite_load_bfont("test1.json");

t_cmd = ds_map_create();
t_cmd[?"$"] = Textwrite_type.cmd_draw;
t_cmd[?"#"] = Textwrite_type.cmd_step;

cmds = ds_map_create();

cmds[?"c_yellow"] = function () begin
	//tw_state.set_col_mono(c_yellow);
	static c = $128192;
	tw_state.point_cols = [
		c_yellow, c_yellow,
		c, c
	];
end

cmds[?"c_red"] = function () begin
	tw_state.set_col_mono(c_red);
end

cmds[?"c_black"] = function () begin
	static c = 0;//$4a1114;
	static c2 = $6b181c;
	tw_state.point_cols = [
		c2, c2,
		c, c
	];
	//tw_state.set_col_mono(c_black);
end

cmds[?"~c"] = function () begin
	tw_state.set_col_mono(c_white);
end

cmds[?"test_yote"] = function () begin
	matrix_world_set(matrix_build_identity())
	matrix_multiply_world(matrix_build(-80,-80,0, 0,0,0, 1,1,1));
	matrix_multiply_world(matrix_build(0,0,0, 0,0,sin(time() * 2) * 4, 2,2,2));
	matrix_multiply_world(matrix_build(64,64,depth+2, 0,0,0, 1,1,1));
	draw_sprite_ext(spr_yote, 0, 0, 0, 1, 1, 0, c_grey, 1.);
	matrix_world_reset();
end

t_str = "$test_yote$I $c_black$see $c_yellow$it$~c$, I saw $c_red$it$~c$.\nHave you?";
t_dialog = textwrite_make_sequence(t_str, t_cmd);

t_dialog_ind = 0;
t_dialog_len = array_length(t_dialog) -1 ;
t_speaksfx = -1;

function on_new_ind () begin
	var elem = t_dialog[t_dialog_ind];
	var is_end = t_dialog_ind == t_dialog_len;
	
	if (is_string(elem))
	{
		if (elem == " " || elem == "\n" || elem == "\t")
		{
			if (is_end)
				return;
			
			t_dialog_ind++;
			on_new_ind();
			return;
		} 
		else
		{
			if (audio_is_playing(t_speaksfx))
				audio_stop_sound(t_speaksfx);
			
			t_speaksfx = audio_play_sound(sfx_speak_generic, 1, false);
			audio_sound_gain(t_speaksfx, 1., 0.);
			
		}
		
	}
	else if (elem == Textwrite_type.cmd_step)
	{
		var cmd = t_dialog[++t_dialog_ind];
		if (ds_map_exists(cmds, cmd))
			cmds[?cmd]();
			
		return;
		
	}
	else if (elem == Textwrite_type.cmd_draw)
	{
		t_dialog_ind+=2;
		return;
	}
	
end
