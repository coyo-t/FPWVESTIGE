/// @desc
if (madness > 1)
{
	if (madness_change_cooldown <= 0)
	{
		madness_change_cooldown = madness_change_max;
		if (irandom(10) < 5)
		{
			madness_sprite_wigout = (irandom(20) < 1) && (madness / madness_max >= 0.95);
		
			if (irandom(madness_sprite_rare_chance) <= 1) // use rare
			{
				madness_current_sprite = madness_sprites_rare[irandom(array_size(madness_sprites_rare) - 1)];
			
				switch (madness_current_sprite)
				{
					case spr_char_ico_annuii:
					case spr_char_ico_miana:
					case spr_char_ico_tam:
					case spr_char_ico_vlasta:
					case spr_char_ico_eoc:
					case spr_lizz_panic_arma:
					case spr_lizz_panic_klage:
					case spr_lizz_panic_agent:
						madness_sprite_blendmode = bm_max;
						madness_sprite_blur = 0.025;
						madness_sprite_wigout = false;
						break;
						
					default: 
						madness_sprite_blendmode = bm_subtract;
						madness_sprite_blur = .08;
						break;
				}
			
			} else {
				madness_current_sprite = madness_sprites[irandom(array_size(madness_sprites) - 1)];
			
				switch (madness_current_sprite)
				{
					case spr_lizz_panic_phosphor:
						madness_sprite_blendmode = bm_max;
						madness_sprite_blur = 0.05;
						break;
						
					case spr_ekka_circuit:
						madness_sprite_wigout = true;
						madness_sprite_blur = 0;
						break;
						
					default: 
						madness_sprite_blendmode = bm_subtract;
						madness_sprite_blur = .08;
						break;
						
				}
			}
		}
	
		madness_show_sprite = irandom(10) < 5;
	
	} else {
		madness_change_cooldown -= dt();
	}
}

if (DEBUG)
{
	if (keyboard_check(vk_delete))
	{
		affect_rate(32);
		//madness = madness_max + 1;
		//madness_target = madness_max + 1;
	}
}
