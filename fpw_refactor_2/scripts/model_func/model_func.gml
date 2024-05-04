begin
	vertex_format_begin();
	vertex_format_add_position_3d();
	vertex_format_add_texcoord();
	vertex_format_add_colour();
	_G.vformat_xyz_uv_col = vertex_format_end();
	
	vertex_format_begin();
	vertex_format_add_position();
	vertex_format_add_texcoord();
	vertex_format_add_colour();
	_G.vformat_xy_uv_col = vertex_format_end();
	
	vertex_format_begin();
	vertex_format_add_position_3d();
	vertex_format_add_colour();
	_G.vformat_xyz_col = vertex_format_end();
	
	vertex_format_begin();
	vertex_format_add_position();
	vertex_format_add_texcoord();
	_G.vformat_xy_uv = vertex_format_end();
end

function draw_line_3d (vb, x0, y0, z0, x1, y1, z1, _c)
{
	_c = (_c & $FF00FF00) | ((_c & $00FF0000) >> 16) | ((_c & $000000FF) << 16);
	vertex_position_3d(vb, x0, y0, z0);
	vertex_argb(vb, _c);
	vertex_position_3d(vb, x1, y1, z1);
	vertex_argb(vb, _c);
}

function add_point_3d_uv (vb, _x, _y, _z, _u, _v, _c)
{
	_c = (_c & $FF00FF00) | ((_c & $00FF0000) >> 16) | ((_c & $000000FF) << 16);
	vertex_position_3d(vb, _x, _y, _z);
	vertex_texcoord(vb, _u, _v);
	vertex_argb(vb, _c);
}

function draw_cube_outline (vb, x0, y0, z0, x1, y1, z1, _c)
{
	draw_line_3d(vb, x0,y0,z0, x1,y0,z0, _c); // 000 100
	draw_line_3d(vb, x0,y0,z0, x0,y1,z0, _c); // 000 010
	draw_line_3d(vb, x0,y1,z0, x1,y1,z0, _c); // 010 110
	draw_line_3d(vb, x1,y0,z0, x1,y1,z0, _c); // 100 110
	
	draw_line_3d(vb, x0,y0,z1, x1,y0,z1, _c); // 001 101
	draw_line_3d(vb, x0,y0,z1, x0,y1,z1, _c); // 001 011
	draw_line_3d(vb, x0,y1,z1, x1,y1,z1, _c); // 011 111
	draw_line_3d(vb, x1,y0,z1, x1,y1,z1, _c); // 101 111
	
	draw_line_3d(vb, x0,y0,z0, x0,y0,z1, _c); // 000 001
	draw_line_3d(vb, x0,y1,z0, x0,y1,z1, _c); // 010 011
	draw_line_3d(vb, x1,y0,z0, x1,y0,z1, _c); // 100 101
	draw_line_3d(vb, x1,y1,z0, x1,y1,z1, _c); // 110 111
}

