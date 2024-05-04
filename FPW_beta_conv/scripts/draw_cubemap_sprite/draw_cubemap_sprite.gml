///@arg sprite
///@arg model
function draw_cubemap_sprite(argument0, argument1) {
	var mdl = argument1;
	var spr = argument0;
	var rot = [
		0, 90,
		0, 0,
		0, -90,
		0, 180,
		-90, 0,
		90, 0
	]

	var m = matrix_get(matrix_world);

	var i = 0;

	repeat (6)
	{
		var rot_pitch = rot[i * 2];
		var rot_yaw   = rot[(i * 2) + 1];
	
		matrix_set(
			matrix_world,
			matrix_build(0, 0, 0, rot_pitch, rot_yaw, 0, 1, 1, 1)
		);
	
		vertex_submit(mdl, pr_trianglelist, sprite_get_texture(spr, i));
	
		++i;
	}

	matrix_set(matrix_world, m);



}
