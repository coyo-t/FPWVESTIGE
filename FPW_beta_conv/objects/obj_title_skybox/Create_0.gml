/// @desc
sky_fov = fov_h2v(90, RESW, RESH);
sky_fov_last = sky_fov;
sky_pitch = 0;
sky_yaw   = 0;
sky_roll  = 0;

function rebuild_proj () begin
	static znear = 0.01;
	static zfar = $FF;
	sky_projmat = matrix_build_projection_perspective_fov(sky_fov, RESA, znear, zfar);
	camera_set_proj_mat(sky_cam, sky_projmat);
	
end

do_draw_skybox = true;

//current_planet = spr_title_planet_earth;

sky_mdl = [
	"planetDiorama_sky.vbm",
	"planetDiorama1.vbm"
];

sky_mdl_tex = [
	spr_title_envbkd,
	spr_title_planet_earth
];

for (var i = 0; i < array_size(sky_mdl); i++)
{
	sky_mdl[i] = model_load_vbm(BASEPATH+"mdl/"+sky_mdl[i], _G.vform_shadeless, true);
}

//sky_mdl = model_load_vbm(BASEPATH+"mdl/sphere_generic.vbm", _G.vform_shadeless, true);

sky_projmat = -1;
sky_viewmat = matrix_build(0,0,0, 0,0,0, 1,1,1);

sky_cam = camera_create();
camera_set_view_mat(sky_cam, sky_viewmat);
rebuild_proj();


function update_camera (cstate) begin
	do_draw_skybox = cstate.do_draw_skybox;

	if (cstate.do_draw_skybox)
	{
		var lerpspd = 0.001;
		
		sky_yaw   = lerp_dt(sky_yaw,   cstate.bkd_yaw,   lerpspd);
		sky_pitch = lerp_dt(sky_pitch, cstate.bkd_pitch, lerpspd / 2);
		sky_roll  = lerp_dt(sky_roll,  cstate.bkd_roll,  lerpspd);

		matrix_stack_push(matrix_build(
			0,0,0, 
	
			0,0, sky_roll + (sin(time() / 2) * 2), 
	
			1,1,1
		));

		matrix_stack_push(matrix_build(
			0,0,0, 
	
			sky_pitch,
			sky_yaw, 
			0, 
	
			1,1,1
		));

		sky_viewmat = matrix_stack_top();

		matrix_stack_pop();
		matrix_stack_pop();
	
		sky_fov = lerp_dt(sky_fov, cstate.bkd_fov, lerpspd);
	
		if (sky_fov != sky_fov_last)
			rebuild_proj();
	
	}

end
