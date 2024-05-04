/// @desc
matrix_world_set(
	matrix_build(0, (sin(time() * 0.75) * 16), 0, 0,0,0, 1,1,1
));

draw_self();

matrix_world_reset();
