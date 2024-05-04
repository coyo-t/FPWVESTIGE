/// @desc
if (!script_exists(draw_routine)) { exit; } else
{
	//light_surface = surface_create_unexist_depthless(light_surface, sprite_width, sprite_height);
	
	if (timeline_running)
	{
		image_blend = colour_mix(light_colour_lo, light_colour_hi, timeline_pos_nrm);
	} else {
		var t = time() * .5;
		var pi1 = pi * .5;
		var vari = ((sin(t) + sin(t * 3)) + pi1) / pi1; 
		image_blend = colour_mix(light_colour_hi, light_colour_hi_dim, vari);
	}
	
	gpu_push_state();
	gpu_set_blendmode(bm_add);
	
	//image_alpha = lerp_dt(image_alpha, is_on, 0.000001);
	//image_alpha = clamp(image_alpha, 0., 1.);
	
	var parn = parent_door != noone ? parent_door.anim_frame == -1 : true;
	
	if (is_on && parn)
	{
		script_execute(draw_routine);
		
	}
	gpu_pop_state();
}
