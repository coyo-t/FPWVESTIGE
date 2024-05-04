switch (current_state)
{
	case state_room:
		current_state.render_office(self);
		current_state.render_ui(self);
		break;
	case state_cctv:
		current_state.render(self);
		break;
}

gpu_push_state();
gpu_set_ztestenable(false);
gpu_set_zwriteenable(false);
gpu_set_alphatestenable(false);
gpu_set_blendmode(bm_subtract);
gpu_set_texfilter(true);
draw_sprite_stretched_ext(spr_vinyet, 0, 0, 0, ref_w, ref_h, $8f8f8f, 1.);

{
	var fac = player.panic.get_fac(timer.a);
	var bc = floor(fac * fac * 255)
	draw_sprite_stretched_ext(
		spr_panic_placeholder, 0,
		0, 0,
		ref_w, ref_h,
		bc | (bc << 8) | (bc << 16),
		1.
	);
}
gpu_pop_state();
