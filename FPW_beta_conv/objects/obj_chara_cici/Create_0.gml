/// @desc

function trigger_scr () begin
	var o = obj_cctv;
	
	return o.state_changed && !o.is_cctv_active;
	
end

// Inherit the parent event
event_inherited();

allowed_rooms = make_allowed([
	"droid_start",
	
	"main_1",
	"main_3",
	
	"hall_l_1",
	"hall_l_2",
	
	"hall_r_1",
	"hall_r_2",
	
	"interro",
	
	"airlock_l",
	"airlock_r",
	
	"player"
]);
