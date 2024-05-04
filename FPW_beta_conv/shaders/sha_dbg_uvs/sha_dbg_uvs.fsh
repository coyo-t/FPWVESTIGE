//
// Simple passthrough fragment shader
//
varying vec2 v_uvs;
varying vec4 v_col;

void main ()
{
	gl_FragColor = v_col * vec4(v_uvs.xy, 0., 1.);
}
