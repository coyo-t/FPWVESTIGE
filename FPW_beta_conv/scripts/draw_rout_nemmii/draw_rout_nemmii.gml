/*
//#region nemmii vertical
//begin
//	_G.text_nemmii_vertical = ds_map_create();
//	_G.text_nemmii_vertical[? "sprite"] = spr_nemmii_letters_vertical;
//	_G.text_nemmii_vertical[? "charmap"] = json_decode(file_text_openToString(BASEPATH+"nemmii_vertical_map.json"))
	
//end
//#endregion

function __nemmii_init () begin
	//enum nemmii_charcodes {
	//	fa      = $02, // carrot
	//	ff      = $03,

	//	ta      = $04, // triangle
	//	tt      = $05,
	
	//	ra      = $06, // sickle
	//	rr      = $07,
	
	//	da      = $08, // key
	//	dd      = $09,
	
	//	nach    = $0A, // lightning
	//	nnch    = $0B,
	
	//	sazhin  = $0C, // square
	//	sszhin  = $0D,
	
	//	na      = $0E, // b
	//	nn      = $0F,
	
	//	ana     = $10, // hook
	//	ann     = $11,
	
	//	ba      = $12, // heart
	//	bb      = $13,
	
	//	ma      = $14, // arch
	//	mng     = $15,
	
	//	numa    = $16, // spear
	
	//	pa      = $17, // mountains
	//	pp      = $18,
	
	//	ga      = $19, // farris
	//	gg      = $1A,
	
	//	ka      = $1B, // diamond
	//	kk      = $1C,
	
	//	la      = $1D, // arch
	//	ll      = $1E,

	//	zero    = $1F, // NUBMARZ MASON
	//	one     = $20,
	//	two     = $21,
	//	three   = $22,
	//	four    = $23,
	//	five    = $24,
	//	six     = $25,
	//	seven   = $26,

	//	space           = $00,
	//	newline         = $01,

	//	verb_start      = $27, // (
	//	verb_end        = $28,
	
	//	group_start     = $29, // [
	//	group_end       = $2A,

	//	volup_start     = $2B, // {
	//	volup_end       = $2C,

	//	voldown_start   = $2D, // 3
	//	voldown_end     = $2E,
	
	//	question_start  = $2F, // <
	//	question_end    = $30,

	//	adjective_left  = $31, // cross
	//	adjective_right = $32,

	//	adverb_left     = $33, // circuit
	//	adverb_right    = $34,

	//	sentance_stop   = $35, // x
	//	sentance_pause  = $36  // L
	//}

	//enum nemmii_dir {
	//	hori,
	//	vert
	//}



end


function dwrt_nemmii_test () begin
	var fn = spr_nemmii_letters_vertical;
	var char_w = sprite_get_bbox_right(fn);
	var char_h = sprite_get_bbox_bottom(fn);

	var draw_x = mouse_x_real();
	var draw_y = mouse_y_real();

	var dir = nemmii_dir.vert;

	var txt = obj_labyrinth_visuals.d_nemmi_testtext;
	var str = "";
	buffer_seek(txt, buffer_u8, 0);

	var chx = 0;
	var chy = 0;

	for (var i = 0; i < buffer_get_size(txt); i+=2)
	{
		var read_char = buffer_peek(txt, i, buffer_u8);
		var read_prop = buffer_peek(txt, i+1, buffer_u8);
	
		var prop_vowel = read_prop & $03;
		var prop_num_negative = (read_prop & $04) >> 2;
		var prop_long_vowel   = (read_prop & $08) >> 3;
		var prop_long_cons    = (read_prop & $10) >> 4;
	
		print(nemmii_decode(read_char) + " "+ string(read_prop & $03));
	
		var map = _G.text_nemmii_vertical[? "charmap"];
		var loc  = map[? nemmii_decode(read_char) + "_" + string(prop_vowel)];
	
	
		draw_sprite_part(
			fn, 0, 
			loc[| 0] * char_w, 
			loc[| 1] * char_h,
			loc[| 2] * char_w, 
			loc[| 3] * char_h,
			draw_x + chx, draw_y + chy
		)

		if (prop_long_vowel)
		{
			var p = map[? "long_vowel"];
			draw_sprite_part(
				fn, 0, 
				p[| 0] * char_w, 
				p[| 1] * char_h,
				p[| 2] * char_w, 
				p[| 3] * char_h,
				draw_x + chx, draw_y + chy + ((loc[| 3] * char_h) - char_h)
			)
		
		}
	
		if (prop_long_cons)
		{
			var p = map[? "long_cons"];
			draw_sprite_part(
				fn, 0, 
				p[| 0] * char_w, 
				p[| 1] * char_h,
				p[| 2] * char_w, 
				p[| 3] * char_h,
				draw_x + chx, draw_y + chy
			)
		
		}
	
		if (prop_num_negative)
		{
			var p = map[? "num_negative"];
			draw_sprite_part(
				fn, 0, 
				p[| 0] * char_w, 
				p[| 1] * char_h,
				p[| 2] * char_w, 
				p[| 3] * char_h,
				draw_x + chx, draw_y + chy
			)
		
		}

		//newline
		if (read_char == $01)
		{
			if (dir == nemmii_dir.vert)
			{
				chx += char_w * loc[| 2];
				chy = 0;
			} else {
				chy += char_h * loc[| 3];
				chx = 0;
			}
		} else {
			if (dir == nemmii_dir.vert)
			{
				chy += char_h * loc[| 3];
			} else {
				chx += char_w * loc[| 2];
			}
		}

	}

end


///@arg code
function nemmii_decode (argument0) begin
	switch (argument0)
	{
		case $00: return "space";
		case $01: return "newline";
	
		case $02: return "fa"; //carrot
		case $03: return "ff";
	
		case $04: return "ta"; //triangle
		case $05: return "tt";
	
		case $06: return "ra"; //sickle
		case $07: return "rr";
	
		case $08: return "da"; //key
		case $09: return "dd";
	
		case $0a: return "nach"; //ligntning
		case $0b: return "nnch";
	
		case $0c: return "sazhin"; //square
		case $0d: return "sszhin";
	
		case $0e: return "na"; //b
		case $0f: return "nn";
	
		case $10: return "ana"; //hook
		case $11: return "ann";
	
		case $12: return "ba"; //heart
		case $13: return "bb";
	
		case $14: return "ma"; //arch
		case $15: return "mng";
	
		case $16: return "numa"; //spear
	
		case $17: return "pa"; //mountains
		case $18: return "pp";
	
		case $19: return "ga"; //farris
		case $1a: return "gg";
	
		case $1b: return "ka"; //diamond
		case $1c: return "kk";
	
		case $1d: return "la"; //bow
		case $1e: return "ll";
	
		case $1f: return "zero"; //nUBMARZ MASON
		case $20: return "one";
		case $21: return "two";
		case $22: return "three";
		case $23: return "four";
		case $24: return "five";
		case $25: return "six";
		case $26: return "seven";
	
		case $27: return "verb_start"; //(
		case $28: return "verb_end";
	
		case $29: return "group_start"; //[
		case $2a: return "group_end";
	
		case $2b: return "volup_start"; //{
		case $2c: return "volup_end";
	
		case $2d: return "voldown_start"; //3
		case $2e: return "voldown_end";
	
		case $2f: return "question_start"; //<
		case $30: return "question_end";
	
		case $31: return "adjective_left"; //cross
		case $32: return "adjective_right";
	
		case $33: return "adverb_left"; //circuit
		case $34: return "adverb_right";
	
		case $35: return "sentance_stop"; //x
		case $36: return "sentance_pause"; //L
	
		default: return "space";
	
	}

end

*/
