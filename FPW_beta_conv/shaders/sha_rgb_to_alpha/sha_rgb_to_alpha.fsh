//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
	vec4 col = texture2D(gm_BaseTexture, v_vTexcoord);
	gl_FragColor = vec4(col.rgb * v_vColour.rgb, ((0.2126*col.r) + (0.7152*col.g) + (0.0722*col.b)) * v_vColour.a * col.a);
}
