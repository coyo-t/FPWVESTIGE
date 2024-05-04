// these take up memory and are not destroyed by the engine,
// and so must be manually removed as to not clog up the
// game's memory usage (which would eventually slow, halt, or
// even crash the game).
// I think you know what a memory leak is though soo..
vertex_format_delete(format);
vertex_delete_buffer(model);

buffer_delete(surf_buff);

if (surface_exists(surf))
{
	surface_free(surf);
}
