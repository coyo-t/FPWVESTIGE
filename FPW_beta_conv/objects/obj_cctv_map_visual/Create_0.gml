/// @desc
surface = -1;
alpha_unfocused = 0.25;
alpha_focused = 0.85;

sector_name_shadow_offset = [-1, 2];

navball_frame = spr_navball_frame;
navball_surface = -1;
navball_srf_w = sprite_get_width(navball_frame);
navball_srf_h = sprite_get_height(navball_frame);

navball_mesh = model_load_vbm(BASEPATH + "mdl/sphere_generic.vbm", _G.vform_shadeless, true);
navball_size = 80;
navball_pos = [
	empty_sectortext_pos.x,
	empty_sectortext_pos.y
];
