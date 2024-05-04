/// @desc
camera_destroy(camera);
vertex_delete_buffer(model);
buffer_delete(lookup);

surface_free_if_exists(mdl_surface);
surface_free_if_exists(surface);
