/// @desc
state_changed = was_cctv_on != is_cctv_on;
was_cctv_on = is_cctv_on;
was_cctv_active = is_cctv_active;

cctv_cam_garble_timer = max(cctv_cam_garble_timer - dt(), 0);
cctv_cam_switch_timer = max(animate_and_return(spr_cctv_switch, cctv_cam_switch_timer, -1), -1);

cctv_static_intensity += sign(cctv_static_target_intensity - cctv_static_intensity) * dt() * cctv_static_intensity_delta;
cctv_static_intensity = clamp(cctv_static_intensity, 0, 255);

//debug_push_string("cctv sector id", cctv_current_sector_id.sector_name);

toggled = false;
