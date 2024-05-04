/// @desc

// Inherit the parent event
event_inherited();

madness_inc_rate_base = 40;
madness_inc_rate_ads  = 15;
madness_inc_rate = madness_inc_rate_base + ((aggro_level / (AI_MAX_LEVEL - 1)) * madness_inc_rate_ads);
cooldown_delta = -0.5;

allowed_rooms = make_allowed([
	"bachta",
	
	"medi_1",
	"medi_2",
	"medi_3",
	
	"hall_l_1",
	"hall_l_2",
	
	"interro",
	
	"airlock_l"
]);

psyche_levels = ds_map_create();

var psi_l = [
	"bachta", .78,
	"medi_1", .75,
	"medi_2", .78,
	"medi_3", .7,
	"hall_l_1", .8,
	"hall_l_2", .85,
	"interro", 1.,
	"airlock_l", 1.5
];

for (var i = 0; i < array_size(psi_l);)
{
	var sect = psi_l[i++];
	var amn  = psi_l[i++];
	
	psyche_levels[?sect] = amn;
	
}

//var tst = [
//	[0, "cat"],
//	[1, "dog"],
//	[2, "hehe"],
//	[3, "woww"],
//];

//print(tst);

//array_sort_shuffle(tst);

//array_sort_selection(tst, sort_compare_test);

//print(tst);

