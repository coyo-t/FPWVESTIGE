mom = -1;

has_been_destroyed = false;

mdl_golem = (function (_fp)
{
	var f = buffer_load(_fp);
	var v = vertex_create_buffer_from_buffer(f, _G.vformat_xyz_uv_col);
	buffer_delete(f);
	vertex_freeze(v);
	return v;
})("./mdls/golem_3d.vbm");

map_inst = inst_13BBAA15;

function render ()
{
	//draw_clear(c_black);
	draw_text(mom.ref_w >> 1, mom.ref_h >> 1, "THIS IS THE CCTV DUMMY");
	map_inst.draw(mom);
}

function tick ()
{
	while (mom.input.vore_press("cctv.test_switchback"))
	{
		mom.change_view("office");
		mom.view_office.cctv_flipper.flip_down();
	}
}

function init ()
{
	mom.input.add_input("cctv", "test_switchback", vk_space, "keyboard");
	
}

function switch_from ()
{
	inst_2BC73F35.set_all_visible(false);
	mom.input.set_group_enable("cctv", false);
}

function switch_to ()
{
	mom.input.set_group_enable("cctv", true);
	mom.set_mouse_grab(false);
	inst_2BC73F35.set_all_visible(true);
	mom.can_pause = true;
}

function draw_golem_symbol (_mdl_buffer, _x, _y, _z, _size, _t)
{
	gpu_push_state();
	gpu_set_blendmode(bm_normal);
	gpu_set_alphatestenable(true);
	gpu_set_ztestenable(true);
	gpu_set_zwriteenable(true);
	gpu_set_cullmode(cull_counterclockwise);
	gpu_set_texfilter(1);
		
	mom.mats.push_stack(matrix_build(0,0,0, 35.264*.5, 45 + (_t * 90), 0, 1,1,1))
		.push([1,0,0,0, 0,1,0,0, 0,0,1,1., 0,0,0,1.5])
		.push(matrix_build_ps(
			_x, _y, _z,
			_size,_size,1
		));
			
		
	mom.world.push_stack(mom.mats.bot());
	vertex_submit(_mdl_buffer, pr_trianglelist, -1);
	mom.world.pop_stack();
	mom.mats.pop_stack();
	gpu_pop_state();
}
