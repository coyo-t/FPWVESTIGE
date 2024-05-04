var mx = fpw.get_mouse_x();
var my = fpw.get_mouse_y();

fpw.trans.world.push_stack(matrix_build(
	128, 128, depth,
	0,0,0, 
	128 * 3, 128 * 1.75, 1
));

index += mouse_wheel_up() - mouse_wheel_down();

mdltest.update_texture(index);
mdltest.draw();

fpw.trans.world.pop_stack();

draw_cross(mx, my, 16);
draw_sprite(mdltest.sprite, index, mx, my);
