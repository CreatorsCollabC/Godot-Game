shader_type canvas_item;

uniform float t = 0.5;

vec2 rotate(vec2 a, float r, vec2 offset){
	float c = cos(r); float s = sin(r);
	a = a - offset;
	vec2 b = vec2(a.x * c - s * a.y, a.x * s + a.y * c);
	b = b + offset;
	return b;
}

void fragment()
{
	
	// float t = abs(mod(TIME,2.0) - 1.0);//*0.0 + 1.0;
	
	float s = t*t*t;
	
	vec2 uv = rotate(UV,t * 13.0 - 14.0,vec2(0.5,0.5));
	
	uv = (uv - vec2(0.5,0.5)) / s + vec2(0.5,0.5);
	
	float a = 1. - texture(TEXTURE,uv).r;
	COLOR = vec4(0.,0.,0.,a);
}