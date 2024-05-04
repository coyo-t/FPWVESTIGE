mdl = model_load_vbm("models/statscreen_2d.vbm", _G.vform_shadeless_2d, true);

var mdl_size = room_width / 5;
mdl_matrix = matrix_build(
	0,0,depth,
	0,0,0,
	mdl_size, mdl_size, 1
);

screen_surf = -1;
	surf_w = 256;
	surf_h = 256;

var bgarr = tag_get_asset_ids("stat screen bgs", asset_sprite);
background = bgarr[irandom(array_length(bgarr) - 1)];
