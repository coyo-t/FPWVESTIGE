//
// Simple passthrough fragment shader
//
varying highp vec2 v_vTexcoord;
varying highp vec4 v_vColour;

uniform int dir;

// I really dont want to fucking talk about this
// GLSL ES 2.0 doesnt suppourt bit shifting. Or any bitwise operators.
// Because Fuck You.
// also any hexidecimal literals that go above 0xFFFF cause this GLSL ES
// compiler to fail with literally no explanation besides ""
// im angry.
const int DIR_HORI = (((0x49 * 256) + 0x52) * 256 + 0x4F) * 256 + 0x48;
const int DIR_VERT = (((0x54 * 256) + 0x52) * 256 + 0x45) * 256 + 0x56;

void main ()
{
	// because this is GLSL ES 2.0 we cant use floatBitsToUint().
	// because GLSL ES 2.0 is a fucking cuck. fuck you 2.0, you whore.
	// so we gotta do something *REALLY* shit.
	
	// dont ask.
	highp float coord = (v_vTexcoord.x * float(dir == DIR_HORI)) + (v_vTexcoord.y * float(dir == DIR_VERT));
	
	if (coord <= 0.)
	{
		gl_FragColor = vec4(0., 0., 0., 0.);
		return;
	}
	
	if (coord >= 1.)
	{
		gl_FragColor = vec4(1., 1., 1., 1.);
		return;
	}
	
	highp float frac = fract(coord);
	
	// apparently glsl premultiplies alpha.
	// fun.
	//highp vec4 out_bytes = pow(vec4(10.), vec4(3., 6., 9., 12.));
	highp vec3 out_bytes = pow(vec3(10.), vec3(3., 6., 9.));
	
	out_bytes.rgb *= frac;
	out_bytes.rgb = mod(floor(out_bytes.rgb), 1000.) / (1000. - 1.);
	
	gl_FragColor = vec4(out_bytes, 1.);
}
