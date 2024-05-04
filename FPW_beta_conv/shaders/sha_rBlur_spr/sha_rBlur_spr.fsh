//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float amount_x;
uniform float amount_y;
uniform float uvs[4];
uniform vec4 col;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main()
{
	//float amount = 0.1;
	
	gl_FragColor = col * texture2D(
		gm_BaseTexture, vec2(
			clamp(v_vTexcoord.x + (rand(v_vTexcoord.xy) * (amount_x * 0.1)), uvs[0], uvs[2]),
			clamp(v_vTexcoord.y + (rand(v_vTexcoord.yx) * (amount_y * 0.1)), uvs[1], uvs[3])
		)
	);
}
