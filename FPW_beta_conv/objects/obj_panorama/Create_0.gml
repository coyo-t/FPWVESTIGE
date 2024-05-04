/// @desc
event_inherited();
override_shader_set = true;

override_func = function () begin
	shader_set(sha_distortUv);
	var ss = shader_get_sampler_index(sha_distortUv, "texture");
	texture_set_stage(ss, surface_get_texture(surface));
	gpu_set_texfilter_ext(ss, true);
	gpu_set_tex_mip_bias_ext(ss, 0);

	draw_sprite_ext(
		spr_panoUvTst, 0, bbox_left, bbox_top,
		1., 1.,
		0, 
		image_blend,
		image_alpha
	);

end
