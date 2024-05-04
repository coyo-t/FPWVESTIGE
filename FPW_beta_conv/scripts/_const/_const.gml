function __null () begin end

enum collide_return {
	none = 0,
	inside = 1,
	overlap = 2
}

enum p_arr {
	x = 0,
	y = 1,
	w = 2,
	h = 3
}

enum cbmp_faces {
	left = 0,
	front = 1,
	right = 2,
	back = 3,
	up = 4,
	down = 5
}

#macro RANDOMIZE true

#macro BASEPATH            "./bin/"
#macro SCREENSHOT_SAVE_LOC "C:/Users/Chymic/Pictures/gmDebugImg/"
#macro DSKT                "C:/Users/Chymic/Desktop/"

#macro RESW 1280
#macro RESH 720
#macro RESA (RESW/RESH)

//#macro STARTINGROOM room_make_model
#macro STARTINGROOM room_title
#macro AI_MAX_LEVEL 11
#macro AI_MAX_LEVEL_R (1 / AI_MAX_LEVEL) // Reciprocal

#macro pi 3.1415926535
#macro pi_r 0.31830988618379 //1 / pi //reciprocal shit
#macro SQRT2 0.70710678118655 //1 / sqrt(2) 
#macro HEXCOL 0.003921568627451 //1 / 255
#macro RECP_1024 0.0009765625 // 1 / 1024

#macro c_grey c_gray
#macro c_dkgrey c_dkgray
#macro c_bleu c_blue
#macro file_r 0
#macro file_w 1
#macro file_rw 2

_G.panoStretch  = 0.1;
_G.panoCompress = .25;

var fn_alpha_lower = "abcdefghijklmnopqrstuvwxyz";
var fn_alpha_upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

_G.font_debug_default = draw_get_font();
_G.font_debug = font_add_sprite_ext(
	__spr_font_debugInfo,
	" !\"#$%&'()*+,-./0123456789:;<=>?@"+fn_alpha_upper+"[\\]^_"+fn_alpha_lower+"{|}~",
	false, 0
);

_G.font_cc = font_add_sprite_ext(
	spr_font_cc,
	"0123456789.,:;'?!+_ABCDEFGHIJKLMNOP#-+QRSTUVWXYZ@`~^\"|%*&abcdefghijklmnop$/\\qrstuvwxyz()[]{}<> ",
	false, 0
)

//_G.gui_state_stack  = ds_stack_create();

_G.debug_text_stack = ds_stack_create();
_G.debug_text_halign = fa_right;
_G.debug_text_valign = fa_top;
