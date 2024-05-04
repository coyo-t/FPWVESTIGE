/// @desc
function affect_rate (delta) begin
	madness_rate += delta;
end

madness = 0;
madness_target = 0;
madness_draw_routine = dwrt_lizz_panic;
madness_max = 512;
madness_normalized = 0;
madness_rate_default = 0;//-10;
madness_rate = madness_rate_default;

madness_sprites = [
	spr_lizz_panic_screaming,
	spr_lizz_panic_radio2,
	spr_lizz_panic_radio3,
	spr_lizz_panic_phosphor,
	spr_lizz_panic_screaming2,
	spr_lizz_panic_oldcici,
	spr_lizz_panic_h_18,
	spr_lizz_panic_h_13,
	spr_lizz_panic_grill,
	spr_lizz_panic_burnt,
	spr_lizz_panic_dhdh,
	spr_lizz_panic_tele1,
	spr_lizz_panic_tele2,
	spr_lizz_panic_klage,
	spr_lizz_panic_agent,
	//spr_ekka_circuit,
];

madness_sprites_rare = [
	spr_lizz_panic_time,
	spr_lizz_panic_space,
	spr_lizz_panic_quark,
	spr_lizz_panic_energy,
	spr_lizz_panic_force,
	spr_lizz_panic_void,
	//spr_char_ico_annuii,
	//spr_char_ico_miana,
	//spr_char_ico_tam,
	//spr_char_ico_vlasta,
	//spr_char_ico_eoc,
	spr_cam_flip,
	spr_lizz_panic_arma,
	spr_lizz_panic_tele3,
	spr_lizz_panic_klage,
];

madness_haluc_sfx = [
	sfx_deadlock_haluc_1, 0.75,
	sfx_jakl_laugh_1, 0.75,
	sfx_amb_random_comecloser, 16.,
	sfx_amb_random_parallel_office, 16.,
	//sfx_haluc_shattarm, 0.8,
	sfx_haluc_crying, 0.125,
	sfx_haluc_horror_scream, 0.25,
	sfx_haluc_crash_muffled, 1.5,
	sfx_haluc_dash9_1, 1,
	sfx_haluc_dash9_2, 1,
	sfx_haluc_dash9_3, 1,
	sfx_haluc_gp38_horn, .55,
];

madness_haluc_cooldown_max = 5;
madness_haluc_cooldown = madness_haluc_cooldown_max;
madness_haluc_sound = -1;
madness_haluc_last = -1;

madness_sprite_blendmode = bm_subtract;
madness_sprite_rare_chance = 50;
madness_sprite_blur = .1;
madness_sprite_wigout = false;

madness_change_max = 0.25;
madness_change_cooldown = madness_change_max;

madness_current_sprite = madness_sprites[irandom(array_size(madness_sprites) - 1)];
madness_show_sprite = true;

madness_sound_asset = sfx_lizz_panic;
madness_sound = audio_play_sound(madness_sound_asset, 10, true);
madness_sound_pos = 0;
audio_sound_gain(madness_sound, 0., 0);

madness_hit_max = false;

//madness_mesh = vertex_create_buffer();
//madness_mesh_verts = [
//	[0., 0., 0., 0.], [.5, 0., .5, 0.], [1., 0., 1., 0.],
//	[0., .5, 0., .5], [.5, .5, .5, .5], [1., .5, 1., .5],
//	[0., 1., 0., 1.], [.5, 1., .5, 1.], [1., 1., 1., 1.]
//];
//madness_mesh_tris  = [
//	[0, 1, 3], [3, 1, 4],
//	[1, 2, 4], [4, 2, 5],
//	[3, 4, 6], [6, 4, 7],
//	[4, 5, 7], [7, 5, 8]
//];


//vertex_begin(madness_mesh, _G.vform_shadeless);

//vertex_end(madness_mesh);
