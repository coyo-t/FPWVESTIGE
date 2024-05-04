if (is_enabled)
{
	var mx = fpw.get_mouse_x();
	var my = fpw.get_mouse_y();

	hitbox.from_instance_bbox();
	hitbox.y1 = infinity;
	var in_bounds = hitbox.point_inside(mx, my);
	
	in_bounds |= keyboard_check_pressed(vk_control);
	
	is_flip_anim = flip_anim.is_animating();
	var mover = !was_mouse_over && in_bounds;
	
	// start flipping up
	if (mover && !is_cctv_on && !is_flip_anim)
	{
		flip_anim.flip_up();
		
	}
	
	// start flipping down
	if (mover && is_cctv_on && !is_flip_anim)
	{
		flip_anim.flip_down();
	}
	
	was_mouse_over = in_bounds;
	
	visible = !was_mouse_over && !is_flip_anim;
	
}
else
{
	was_mouse_over = false;
	
}
