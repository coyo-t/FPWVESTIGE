/// @desc
#region functions
function select_new_show () begin
	if (layer_sequence_exists(show_layer, show_seq_id))
		layer_sequence_destroy(show_seq_id);
		
	var s_id = array_rand(show_seqs);
	
	while (s_id == show_seq_curr) s_id = array_rand(show_seqs);
	
	show_seq_curr = s_id;
	show_seq_id = layer_sequence_create(show_layer, 0, 0, s_id);
	
end


function disable () begin
	is_enabled = false;
	is_tv_on = false;
	if (layer_sequence_exists(show_layer, show_seq_id))
	{
		layer_sequence_destroy(show_seq_id);
	}
	
end

#endregion

is_enabled = true;

model_monitor = model_load_vbm(BASEPATH+"mdl/calmtv.vbm", _G.vform_shadeless, true);
screen_surface = -1;
screen_size = 256;
model_size = 2560/5;

screen_z = empty_monitor_depth.depth;

scanline_shade = make_colour_shade(32);

is_tv_on = false;

startup_fade = 1.;
startup_anim = spr_stats_startup;
startup_timer = -1;
startup_timer_end = sprite_get_number(startup_anim);
startup_ended = false;

drain_affect_max = 2;
drain_affect = 0;

{
	var i = inst_ctv_bounds;
	bounds = new rect(i.bbox_left, i.bbox_top, i.bbox_right, i.bbox_bottom);
}

show_seqs = [
	seq_tv_test1,
	seq_tv_tes2
];

show_layer = layer_get_id("lyr_tv_sequence");

layer_script_begin(show_layer, scr_lyr_calmtv_begin);
layer_script_end(show_layer, scr_lyr_calmtv_end);

show_seq_id = -1;
show_seq_curr = -1;
select_new_show();
