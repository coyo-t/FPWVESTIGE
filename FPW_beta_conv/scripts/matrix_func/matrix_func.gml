#macro CENTREMAT matrix_build(0, 0, 0, 0, 0, 0, 1, 1, 1)
#macro LOOKFORWARDS matrix_build_lookat(0,0,0, 0, 0, 1, 0, 1, 0)
#macro ZNEAR 0.01
#macro ZFAR 3200

_G.wmat_stack = ds_stack_create();

///@arg matrix
function matrix_world_set (matrix) begin
	ds_stack_push(_G.wmat_stack, matrix_get(matrix_world));
	matrix_set(matrix_world, matrix);
end


function matrix_world_reset () begin
	if (!ds_stack_empty(_G.wmat_stack))
	{
		matrix_set(matrix_world, ds_stack_pop(_G.wmat_stack));
	}
end


function camera_inverse_mat () begin
	var c = view_camera[view_current];

	return matrix_build(
		camera_get_view_x(c), camera_get_view_y(c), 0,
		0, 0, 0,
		1, 1, 1
	);
end


///@arg matrix
function matrix_multiply_world (matrix) begin
	matrix_set(
		matrix_world,
		matrix_multiply(
			matrix_get(matrix_world),
			matrix
		)
	);
end