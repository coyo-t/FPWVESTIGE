// gamemaker is really anal about surfaces not existing,
// since they're "volatile" and "can stop existing at any time"
// so we have to make extra sure it exists before we touch it,
// or recreate it if its gone kaput
if (!surface_exists(surf))
{
	surf = surface_create(sw, sh);
}

if (surface_exists(surf))
{
	// move the camera to the centre of the world but at our object's depth,
	// and scale up the model to pixel coordinates, since the panorama
	// model is stored really really tiny.
	fpw.trans.world.push_stack(matrix_build(0, 0, depth, 0, 0, 0, sw, sh, 1));
	fpw.trans.view.push_stack(matrix_build(0, 0, 0, 0,0,0, 1,1,1));
	
	// move the screen's contents to the middleman surface
	buffer_get_surface(surf_buff, appsurf, 0);
	buffer_set_surface(surf_buff, surf, 0);
	
	// get the middleman surface's "texture" (which is where gamemaker
	// stores it in graphics memory)
	var tex = surface_get_texture(surf);
	
	// we enable texture filtering so that it doesnt look pixel-y
	// unless you want it to i guess
	var gf = gpu_get_tex_filter();
	gpu_set_tex_filter(true);
	
	// "submit" the model (aka draw it) to the screen
	// the actual "drawing" comes later with shaders n shit.
	// for now we're just telling the engine that we want these triangles here
	// with this texture.
	vertex_submit(model, pr_trianglelist, tex);

	// reset the camera and texture filtering back to where/what it was
	fpw.trans.world.pop_stack();
	fpw.trans.view.pop_stack();
	gpu_set_tex_filter(gf);
}