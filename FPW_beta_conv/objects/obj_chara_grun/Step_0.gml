/// @desc
if (!is_enabled)
	exit;

cooldown_delta = -1;
var map_info = obj_labyrinth_visuals.map_info;
var is_viewed = false;

if (cooldown <= 0)
{
	cooldown = 2;
	
	if (!ds_queue_empty(path_stack))
	{
		target_sector = ds_queue_head(path_stack);
		
	} else if (ds_queue_empty(path_stack) && current_sector == "interro")
	{
		target_sector = "player";
	}
	
}

if (current_sector != "interro")
{
	var viewing_sector = obj_cctv.cctv_current_sector_id;
	viewing_sector = viewing_sector.sector_name;
	
	is_viewed = viewing_sector == parent_sector && obj_cctv.is_cctv_on;
	
} 
else if (current_sector == "interro")
{
	is_viewed = inst_lightbutton_m.is_on;
	
}

if (is_aggro_max)
{
	ads_move_flag = !is_viewed;
} else {
	cooldown_delta = is_viewed ? cooldown_increase_rate : -1;
}
