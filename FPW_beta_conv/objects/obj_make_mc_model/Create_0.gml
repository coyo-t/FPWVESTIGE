/// @desc
current = 0;
start = false;
tex_path = "C:/Users/Chymic/AppData/Roaming/.minecraft/versions/20w13a/assets/minecraft/textures/item/";
tex_names = [
	"diamond_pickaxe",
	"golden_sword",
	"iron_ingot",
	"string",
	"cooked_porkchop",
	"glass_bottle",
	"egg",
	"music_disc_cat",
	"redstone",
	"iron_pickaxe",
	"ender_pearl"
];

textures = [];

meshes = ds_map_create();

for (var i = 0; i < array_size(tex_names); i++)
{
	textures[i] = sprite_add(tex_path+tex_names[i]+".png", 1, false, false, 0, 0);
}


//mesh = minecraft_create_mesh(textures[0]);
