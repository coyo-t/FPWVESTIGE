mdl = model_load_vbm("models/pano_flat_nrm_2d.vbm", _G.vform_shadeless_2d, 1);

middleman_surf = -1;

srf_w = view_wport[0];
srf_h = view_hport[0];

// todo: create this at-runtime from the above model?
mouse_remap = buffer_load(BASEPATH+"spheremap.lut");

mdl_size_w = view_wport[0];
mdl_size_h = view_wport[0] * (view_hport[0] / view_wport[0]);
