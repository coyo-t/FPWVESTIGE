/// @desc
#region functions
///@arg sprite      the animation to use and get timings from
///@arg ads_time    additional time to wait once the timer hits 0
///@arg return_sect the sector to appear in before going to the player
///@arg sound       sound asset used for when you see her running on the cctv
function route (_spr, _add_time, _ret_sect, _sfx) constructor begin
	spr = _spr;
	spr_time = sprite_get_number(spr) / sprite_get_speed(spr);
	ads_time = -_add_time;
	ret_sect = _ret_sect;
	sfx = _sfx;
	
end

#endregion

// Inherit the parent event
event_inherited();

// in much the same way i hacked together the canine of fnaf1,
// i hack together the canine of FPW.
// no munich doesnt count as a canine. i think

is_running = false;
running_timer = 0.; // all times here are in seconds
running_unseen_multi = 3.5; // if you dont look at her, how much longer should the timer last
has_been_seen = false;

var cd_start_mul = .2;
running_cooldown_max = 30;
running_cooldown_min = 6;
running_cooldown = cooldown + (running_cooldown_max * cd_start_mul);
running_cooldown_retard = 0.35;

running_sector = -1;
running_sector_orig = -1;
running_reset_sector = "main_2";
running_anims = ds_map_create();
running_anims[?"bedhall_1"] = new route(
	spr_t_jakl_run_bedhall, // the animation to use and get timings from
	.75,            // additional time to wait once the timer hits 0
	"airlock_r",     // the sector to appear in before going to the player
	sfx_jakl_run_temp
);

hit_player = false;

running_cctv_sfx = -1;
running_cctv_sfx_vol = 0.8;

running_anims[?"bedhall_2"] = running_anims[?"bedhall_1"];

running_anims[?"hall_l_1"] = new route(
	spr_t_jakl_run_bedhall,
	.5,
	"airlock_l",
	sfx_jakl_run_temp
);
running_anims[?"hall_r_1"] = new route(
	spr_t_jakl_run_bedhall,
	.5,
	"airlock_r",
	sfx_jakl_run_temp
);

// maybe give her one for the main area too?

// maybe make an "excluded rooms" instead?
// or let me use parent sectors
allowed_rooms = make_allowed([
	"droid_start",
	
	"main_1",
	"main_2",
	"main_3",
	"main_4",
	
	"hall_l_1",
	"hall_l_2",
	
	"hall_r_1",
	"hall_r_2",
	
	"bedhall_1",
	"bedhall_2",
	"bedhall_3",
	
	"interro",
	
	"medi_1",
	"medi_2",
	"medi_3",
	
	"player"
]);
