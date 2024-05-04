attribute vec3 in_Position;     // (x,y,z)
//attribute vec3 in_Normal;       // (x,y,z)
attribute vec4 in_Colour;       // (r,g,b,a)
attribute vec2 in_TextureCoord; // (u,v)

varying vec2 v_uvs;
varying vec4 v_col;

void main ()
{
	vec4 object_space_pos = vec4(in_Position.xyz, 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;

	v_col = in_Colour;
	v_uvs = in_TextureCoord;
}
