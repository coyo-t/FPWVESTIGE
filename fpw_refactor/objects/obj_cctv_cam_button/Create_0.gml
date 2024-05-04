set_enable = -1;

is_active_cam = false;

if (hitbox != -1 && file_exists(BASEPATH+hitbox))
{
	hitbox = (new Tri_Hitbox())
		.load_legacy(BASEPATH+hitbox)
		.offset(x, y);
}
else
{
	// gamemaker doesnt suppourt per-frame bbox rectangles.
	// nor does this override the read-only bbox vars
	// bogus man.
	hitbox = (new AABB_2d())
		.from_sprite_bbox(mask_override)
		.offset(x, y);
	
	mask_index = mask_override;
	
}

array_push(obj_cctv_map_controller.cam_buttons, id);

function point_inside(px, py)
{
	return hitbox.point_inside(px, py);
}
