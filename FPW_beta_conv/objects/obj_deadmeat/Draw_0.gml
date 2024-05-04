/// @desc
matrix_world_set(camera_inverse_mat());
gpu_push_state();

if (triggered)
{
	draw_sprite_stretched(
		anim, min(anim_frame, sprite_get_number(anim) - 1), 
		0, 0, 
		sprite_get_bbox_right(anim), 
		sprite_get_bbox_bottom(anim)
	);
	
	anim_frame = animate_and_return(anim, anim_frame, 1);
	
}

matrix_world_reset();
gpu_pop_state();
