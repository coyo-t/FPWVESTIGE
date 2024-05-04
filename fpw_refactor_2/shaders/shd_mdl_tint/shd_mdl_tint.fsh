varying vec2 v_uvs;
varying vec4 v_col;

void main ()
{
	gl_FragColor = v_col * texture2D(gm_BaseTexture, v_uvs);
}
