///@arg texture
///@arg side
///@arg model
///@arg size
function draw_cubemap_part(argument0, argument1, argument2, argument3) {
	var mdl = argument2;
	var spr = argument0;
	var rot = [
		0, 90,
		0, 0,
		0, -90,
		0, 180,
		-90, 0,
		90, 0
	];
	var size = argument3;
	var i = argument1;

	var rot_pitch = rot[i * 2];
	var rot_yaw   = rot[(i * 2) + 1];

	matrix_world_set(
		matrix_build(0, 0, 0, rot_pitch, rot_yaw, 0, size, size, size)
	);

	vertex_submit(mdl, pr_trianglelist, spr);

	matrix_world_reset();



}
