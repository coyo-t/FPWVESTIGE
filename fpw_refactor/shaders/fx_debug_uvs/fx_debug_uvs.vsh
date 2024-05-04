attribute vec3 in_Position;
attribute vec2 in_TextureCoord;

varying vec2 v_uvs;

void main ()
{
	vec4 object_space_pos = vec4(in_Position.xyz, 1.);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
	
	v_uvs = in_TextureCoord;
}
