#pragma header

uniform float time;
uniform float strength;
uniform float speed;

float random (vec2 noise) {
	return fract(sin(dot(noise.xy,vec2(10.998,98.233)))*12433.14159265359);
}

void main() {
	vec2 uv = fract(openfl_TextureCoordv.xy*fract(sin(time*speed)));
	
	vec3 colour = vec3(random(uv.xy) - 0.1)*strength;
	vec3 background = vec3(flixel_texture2D(bitmap, openfl_TextureCoordv.xy));
	
	gl_FragColor = vec4(background-colour,1.0);
}