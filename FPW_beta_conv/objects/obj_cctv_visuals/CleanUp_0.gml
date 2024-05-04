/// @desc
vertex_delete_buffer(model_cubemap);
vertex_delete_buffer(model_golem_symbol);
vertex_delete_buffer(model_envmap);
ds_stack_destroy(dwrt_queue);
ds_map_destroy(gpu_state_cube);
camera_destroy(camera_perspective);
camera_destroy(camera_no_offset);

surface_free_if_exists(surface_x);
surface_free_if_exists(surface_y);
surface_free_if_exists(surface_cube);
