if (light_on)
{
	gpu_push_state();
	gpu_set_blendmode(bm_max);
	draw_sprite(light_sprite, 0, 0, 0);
	gpu_pop_state();
}

//image_blend = light_on ? c_red : c_white;
//draw_self();

if (DEBUG && draw_hitbox)
{
	hitbox.draw();
}
