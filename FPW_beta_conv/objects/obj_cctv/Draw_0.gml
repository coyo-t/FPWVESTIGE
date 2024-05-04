/// @desc

if (cctv_anim_frame > -1 && cctv_anim_frame < cctv_anim_count)
{
	matrix_world_set(camera_inverse_mat());
	
	draw_sprite_stretched(
		cctv_anim, cctv_anim_frame, 
		0, 0,
		RESW, RESH
	);
	
	matrix_world_reset();
}

