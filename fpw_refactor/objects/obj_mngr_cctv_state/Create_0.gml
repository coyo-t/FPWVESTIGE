mdl_golem = (function (_fp) {
	var f = buffer_load(_fp);
	var vb = vertex_create_buffer_from_buffer(f, global.vform_shadeless);
	buffer_delete(f);
	return vb
})(BASEPATH+"models/exportertesting.vbm");

input = new InputMap();
input.add("click",     mb_left,  InputKeyType.mouse);
input.add("pancamera", mb_right, InputKeyType.mouse);
input.add("switchback", ord("1"), InputKeyType.keyboard);

function on_switch_to (gs)
{
	gs.set_grab_mouse(false, 1);
}

function tick (gs)
{
	while (input.vore_down("switchback"))
	{
		gs.queue_state_change("room");
		gs.state_room.cctv_transition.flip_down();
	}
}

function step (gs)
{
	input.update();
}

function end_step (gs)
{
	input.end_update();
}

function render (gs)
{
	var cx = 1280 >> 1;
	var cy = 720 >> 1;
	
	draw_clear(c_black);
	
	draw_golem_symbol(mdl_golem, cx, cy, 0, 256);
	draw_text(cx, cy, "THIS IS CCTV YES?");
}


function draw_golem_symbol (_mdl_buffer, _x, _y, _z, _size)
{
	var mats = fpw.trans;
	gpu_push_state();
	gpu_set_blendmode(bm_normal);
	gpu_set_alphatestenable(true);
	gpu_set_ztestenable(true);
	gpu_set_zwriteenable(true);
	gpu_set_cullmode(cull_counterclockwise);
	gpu_set_texfilter(1);
		
	mats.push_stack(matrix_build(0,0,0, 35.264*.5, 45 + (TIME * 90), 0, 1,1,1))
		.push([1,0,0,0, 0,1,0,0, 0,0,1,1., 0,0,0,1.5])
		.push(matrix_build_ps(
			_x, _y, _z,
			_size,_size,_size
		));
			
		
	mats.world.push_stack(mats.bot());
	vertex_submit(_mdl_buffer, pr_trianglelist, -1);
	mats.world.pop_stack();
	mats.pop_stack();
	gpu_pop_state();
}
