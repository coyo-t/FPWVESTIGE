/*----------------
//
//	Panorama Vertical shader by ConstaChymic; Inspired to
//	replace the Panorama object
//
//	http://catsofwar.com
//
----------------*/

#define pi        3.141592653589
#define t2m1(inp) ((inp * 2.0) - 1.0) //times 2, minus 1
#define a1d2(inp) ((inp + 1.0) * 0.5) //add one, divide by 2

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float stretch;
uniform float compress;
uniform bool  isHori;

void main ()
{
	float is_h = float(isHori);
	float is_v = 1. - is_h;
	
	vec2 t = vec2(
		t2m1((v_vTexcoord.x * is_v) + (v_vTexcoord.y * is_h)),
		t2m1((v_vTexcoord.y * is_v) + (v_vTexcoord.x * is_h))
	);

	float cosStep = cos((abs(t.x) * 0.5) * pi);
	float modx    = -(compress / 10.0);
	
	vec2 outCoords = vec2(
		a1d2(t.x / (1.0 + (modx * cosStep))),
		a1d2(t.y / pow(stretch + 1.0, (1.0 - cosStep)))
	);
	
	gl_FragColor = texture2D(gm_BaseTexture, (outCoords * is_v) + (outCoords.yx * is_h)) * v_vColour;
	
}
