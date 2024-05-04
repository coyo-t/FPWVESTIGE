/// @desc
camera_destroy(camera);
vertex_delete_buffer(model);
buffer_delete(point_trans_buff);

surface_free_if_exists(mdl_surface);
surface_free_if_exists(surface);
