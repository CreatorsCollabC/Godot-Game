shader_type canvas_item;


// Noise
uniform float NoiseBlockSize = 5.0;
uniform float NoiseMaxLineWidth = 10.0;
uniform float NoiseMinLineWidth = 5.0;
uniform float NoiseFreq = 10;

uniform bool green_chilli_aura = false;
uniform bool red_chilli_aura = false;
uniform bool ghost_chilli_effect = false;


uniform vec2 offset = vec2(-0.3,-0.8);

const float pi = 3.1415;
const int ang_res = 16;
const int grad_res = 8;


bool pixelInRange(sampler2D text, vec2 uv, vec2 dist) {
	float alpha = 0.0;
	for (int i = 0; i < ang_res; i++) {
		float angle = 2.0 * pi * float(i) / float(ang_res);
		vec2 disp = dist * (vec2(cos(angle), sin(angle))-offset);
		if (texture(text, uv + disp).a > 0.0) return true;
	}
	return false;
}

float getClosestDistance(sampler2D text, vec2 uv, vec2 maxDist) {
	if (!pixelInRange(text, uv, maxDist)) return -1.0;
	
	float hi = 1.0; float lo = 0.0;
	
	for (int i = 1; i <= grad_res; i++) {
		float curr = (hi + lo) / 2.0;
		if (pixelInRange(text, uv, curr * maxDist)) {
			hi = curr;
		}
		else {
			lo = curr;
		}
	}
	return hi;
	
}


float hash(vec2 p, float s) {
	return fract(35.1 * sin(dot(vec3(112.3, 459.2, 753.2), vec3(p, s))));
}

float noise(vec2 p, float s) {
	vec2 d = vec2(0, 1);
	vec2 b = floor(p);
	vec2 f = fract(p);
	return mix(
		mix(hash(b + d.xx, s), hash(b + d.yx, s), f.x),
		mix(hash(b + d.xy, s), hash(b + d.yy, s), f.x), f.y);
}

float getLineWidth(vec2 p, float s) {
	p /= NoiseBlockSize;
	float w = 0.0;
	float intensity = 1.0;
	for (int i = 0; i < 3; i++) {
		w = mix(w, noise(p, s), intensity);
		p /= 2.0;
		intensity /= 2.0;
	}
	
	return mix(NoiseMaxLineWidth, NoiseMinLineWidth, w);
}

vec4 handleNoise(float t,  vec2 pixelSize, sampler2D inputTexture, vec2 inputUV) {
	
	vec4 finalPixelColor;
	float timeStep = floor(NoiseFreq * t);
	vec2 scaledDistance = pixelSize * getLineWidth(inputUV / pixelSize, timeStep);
	float weight = getClosestDistance(inputTexture, inputUV, scaledDistance);
	vec4 starting_colour = red_chilli_aura  ? vec4(1,0,0,1) : vec4(0,1,0,1);
	vec4 ending_colour = green_chilli_aura ?  vec4(0.2,1,0.2,0.5) : vec4(1,0.2,0.2,0.5);
	
	
	if ( weight > 0.0) {
	    finalPixelColor = mix(starting_colour, ending_colour, sqrt(sin(pi * (weight - 0.5)) / 2.0 + 0.5 ));
	} else {
		finalPixelColor = texture(inputTexture, inputUV);
	}
	
	return finalPixelColor;
}

void fragment() {
	vec4 c = texture(TEXTURE,UV);
	vec2 scaledDist = TEXTURE_PIXEL_SIZE;
	vec2 uv = UV ;
	if (ghost_chilli_effect){
		uv += vec2(sin(TIME*5. + UV.y * 10.0) * 0.04 + sin(TIME * 26.5 + UV.y * 15.0) * 0.005,0.0);
	}
	
	c = texture(TEXTURE,uv);
	if (green_chilli_aura || red_chilli_aura){
		if (texture(TEXTURE, uv).a < 0.2) {
			c = handleNoise(TIME, scaledDist, TEXTURE, uv);
		}
	}
	if (ghost_chilli_effect){
		c.a *= sin(TIME*4.0) * 0.3 + 0.4;
	}
	COLOR = c;
}