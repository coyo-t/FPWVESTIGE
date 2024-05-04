/// @desc
screen_surface = surface_create_unexist(screen_surface, RESW, RESH);
surface_clear(screen_surface, c_black);

surface_copy(screen_surface, 0, 0, application_surface);

if (manual_follow)
	matrix_world_set(camera_inverse_mat());

gpu_push_state();

var roomstate = room_states.lizz;

if (room == room_labyrinth_office)
	roomstate = obj_labyrinth_visuals.state;


// cctv screen filth
if (roomstate == room_states.cctv)
{
	gpu_set_blendmode_ext(bm_src_alpha_sat, bm_inv_src_colour);

	draw_sprite_stretched_ext(
		spr_cctv_filth, 0,
		0, 0, RESW, RESH,
		$7a7a7a, 1
	);
	
	gpu_set_blendmode(bm_normal);
	
}

if (roomstate == room_states.lizz) 
{
	// vinyet
	shader_set(sha_rgb_to_alpha);
	gpu_set_texfilter(true);
	gpu_set_blendmode(bm_subtract);
	draw_sprite_stretched_ext(
		spr_vinyet, 0,
		0, 0, RESW, RESH,
		$a1a1a1, 1
	);
	gpu_set_blendmode(bm_normal);
	shader_reset();
}

if (!ds_stack_empty(draw_stack))
{
	do
	{
		var routine = ds_stack_pop(draw_stack);
		script_execute(routine);
		
	} until (ds_stack_empty(draw_stack))
	
}

//shader_set(sha_invert);
//draw_surface(screen_surface, 0, 0);
//shader_reset();

if (blacken > 0)
{
	draw_sprite_stretched_ext(
		spr_null, 0,
		0, 0, RESW, RESH,
		c_black, blacken
	);
	
	blacken = max(blacken - dt(), 0);
	
}

if (manual_follow)
	matrix_world_reset();

gpu_pop_state();
