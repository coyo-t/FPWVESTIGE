is_enabled = true;
light_on = false;
was_light_on = false;

last_mouse = false;

sound_buzz = -1;
	buzz_volume = 0.75;
	buzz_pitch = .8;
	buzz_pitch_vari_base = .1;
	buzz_pitch_vari = buzz_pitch_vari_base;


sound_toggle = -1;


if (hitbox != -1 && file_exists(BASEPATH+hitbox))
{
	hitbox = (new Tri_Hitbox()).load_legacy(BASEPATH+hitbox);
}
else
{
	hitbox = (new AABB_2d()).from_instance_bbox();
}

//debug shit
draw_hitbox = true;

function set_enable (is)
{
	is_enabled = is;
}
