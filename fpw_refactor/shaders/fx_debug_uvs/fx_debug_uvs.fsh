varying vec2 v_uvs;

void main ()
{
	vec4 col = texture2D(gm_BaseTexture, v_uvs);
	gl_FragColor = vec4(v_uvs.xy, 0., col.a);
}
