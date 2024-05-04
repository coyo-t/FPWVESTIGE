///@arg surface
function surface_free_if_exists (surf) begin
	//gml_pragma("forceinline");
	if (surface_exists(surf)) surface_free(surf);
end


///@arg surface
///@arg width
///@arg height
function surface_create_unexist (srf, w, h) begin
	if (!surface_exists(srf))
		return surface_create(w, h);
	else
		return srf;
end


///@arg surface
///@arg width
///@arg height
function surface_create_unexist_depthless (srf, w, h) begin
	if (!surface_exists(srf))
	{
		var d = surface_get_depth_disable();
		surface_depth_disable(true);
		var s = surface_create(w, h);
		surface_depth_disable(d);
		return s;
	} else
		return srf;
end


function surface_clear (surf, colour) begin
	if (surface_exists(surf))
	{
		surface_set_target(surf);
		draw_clear(colour);
		surface_reset_target();
	}
end


function surface_clear_alpha (surf, colour, alpha) begin
	if (surface_exists(surf))
	{
		surface_set_target(surf);
		draw_clear_alpha(colour, alpha);
		surface_reset_target();
	}
end
