///@arg surface
function surface_free_if_exists (surf)
{
	if (surface_exists(surf))
	{
		surface_free(surf);
	}
}


///@arg surface
///@arg width
///@arg height
function surface_create_unexist (srf, w, h)
{
	if (!surface_exists(srf))
	{
		return surface_create(w, h);
	}
	
	return srf;
}


///@arg surface
///@arg width
///@arg height
function surface_create_unexist_depthless (srf, w, h)
{
	if (!surface_exists(srf))
	{
		var d = surface_get_depth_disable();
		surface_depth_disable(true);
		var s = surface_create(w, h);
		surface_depth_disable(d);
		return s;
	} 
	
	return srf;
}


///@arg width
///@arg height
function surface_create_depthless (w, h)
{
	var d = surface_get_depth_disable();
	surface_depth_disable(true);
	var s = surface_create(w, h);
	surface_depth_disable(d);
	return s;
	
}


///@arg surface
///@arg colour
function surface_clear (surf, colour)
{
	if (surface_exists(surf))
	{
		surface_set_target(surf);
		draw_clear(colour);
		surface_reset_target();
	}
}


///@arg surface
///@arg colour
///@arg alpha
function surface_clear_alpha (surf, colour, alpha)
{
	if (surface_exists(surf))
	{
		surface_set_target(surf);
		draw_clear_alpha(colour, alpha);
		surface_reset_target();
	}
}
