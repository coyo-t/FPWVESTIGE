// name is derived from Shattered Star, my d&d character.
// she writes all her spells down as pictures.

enum StarType {
	none = -1, // no texture, only vertex colours
	engine,    // handled by the engine
	asset,     // uses a named sprite+img index in the asset tree
	rgba,      // 8bpp rbg data
	rgb,       // also 8bpp, without transparency
	y,         // 8-bit luma ((r * .299) + (g * .587) + (b * .114))
	ya,        // 8b luma with 8b transparency
}


function star_textype_sizeof (type)
{
	switch (type)
	{
		case StarType.rgba: return 4;
		case StarType.rgb:  return 3;
		case StarType.y:    return 1;
		case StarType.ya:   return 2;
	}
}


function star_tex_decode (bff)
{
	var seek = buffer_tell(bff);
	
	var textype     = buffer_read(bff, buffer_u8);  // technically redundant.
	var data_offset = buffer_read(bff, buffer_u16); // i suppose this is also redundant;
	var fcount      = buffer_read(bff, buffer_u16);
	var frate       = buffer_read(bff, buffer_u16);
	var w           = buffer_read(bff, buffer_u16);
	var h           = buffer_read(bff, buffer_u16);
	var frame_size  = w * h * star_textype_sizeof(textype);
	
	data_offset = buffer_tell(bff);
	
	var spr = -1;
	var bff2 = buffer_create(w * h * 4, buffer_fixed, 1);
	var surf = surface_create_depthless(w, h);
	
	// not pretty i feel.
	repeat (fcount)
	{
		buffer_seek(bff2, buffer_seek_start, 0);
		
		switch (textype)
		{
			case StarType.rgba:
				buffer_copy(bff, data_offset, frame_size, bff2, 0);
				buffer_set_surface(bff2, surf, 0);
			break;
			
			case StarType.rgb:
				repeat (w*h)
				{
					var r = buffer_read(bff, buffer_u8);
					var g = buffer_read(bff, buffer_u8);
					var b = buffer_read(bff, buffer_u8);
					
					buffer_write(bff2, buffer_u8, r); //r
					buffer_write(bff2, buffer_u8, g); //g
					buffer_write(bff2, buffer_u8, b); //b
					buffer_write(bff2, buffer_u8, $ff); //a
				}
				buffer_set_surface(bff2, surf, 0);
			break;
			
			case StarType.y:
			case StarType.ya:
				repeat (w*h)
				{
					var luma = buffer_read(bff, buffer_u8);
					var alpha = textype == StarType.ya ? buffer_read(bff, buffer_u8) : $ff;
					
					buffer_write(bff2, buffer_u8, luma); //r
					buffer_write(bff2, buffer_u8, luma); //g
					buffer_write(bff2, buffer_u8, luma); //b
					buffer_write(bff2, buffer_u8, alpha);
				}
				buffer_set_surface(bff2, surf, 0);
			break;
			
			default:
			break;
			
		}
		
		if (spr == -1)
			spr = sprite_create_from_surface(surf, 0, 0, w, h, 0, 0, 0, 0);
		else
			sprite_add_from_surface(spr, surf, 0, 0, w, h, 0, 0);
			
	}
	
	buffer_delete(bff2);
	surface_free(surf);
	
	sprite_set_speed(spr, frate, spritespeed_framespersecond);
	
	return spr;
	
}
