//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float dep;

float nrm (float ix, float lo, float hi)
{
	lo = abs(lo);
	return (ix + lo) / (lo + hi);
}

void main()
{
	vec4 col = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
	gl_FragColor = vec4(vec3(gl_FragCoord.z / gl_FragCoord.w), col.a);
}
