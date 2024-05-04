//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float amount;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main()
{
	//float amount = 0.1;
	
	gl_FragColor = v_vColour * texture2D(
		gm_BaseTexture, vec2(
			v_vTexcoord.x + (rand(v_vTexcoord.xy) * (amount * 0.1)),
			v_vTexcoord.y + (rand(v_vTexcoord.yx) * (amount * 0.1))
		)
	);
}
