//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
	vec4 col = texture2D(gm_BaseTexture, v_vTexcoord);
	
	gl_FragColor = vec4(
		vec3(1.) - (v_vColour.rgb * col.rgb),
		v_vColour.a * col.a
	);

}
