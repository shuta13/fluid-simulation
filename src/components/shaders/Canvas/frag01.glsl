#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


// a raymarching experiment by kabuto
//fork by tigrou ind (2013.01.22)
// slow mod by kapsy1312.tumblr.com
// grid destruction by echophon

const int MAXITER = 16;

vec3 field(vec3 p) {
	p *= .1;
	float f = .1;
	for (int i = 0; i < 5; i++) {
		p = p.yzx;
		p = abs(fract(p)-.5);
		p *= 2.;
		f *= 2.;
	}
	p *= p;
	return sqrt(p+p.yzx)/f-.01;
	//return sqrt(p+p.yzx)/f-.05;
}


void main( void ) {
	vec3 dir = normalize(vec3((gl_FragCoord.xy-resolution*.5)/resolution.x,1.));
	float a = mouse.x * 0.00021;
	vec3 pos = vec3(0.0,mouse.x*0.0005,mouse.y*-0.00025);
	//camera
	dir *= mat3(1,0,0,0,cos(a),-sin(a),0,sin(a),cos(a));
	dir *= mat3(cos(a),0,-sin(a),0,1,0,sin(a),0,cos(a));
	vec3 color = vec3(0);
	for (int i = 0; i < MAXITER; i++) {
		vec3 f2 = field(pos);
		float f = min(min(f2.x,f2.y),f2.z);
		
		pos += (dir*f)*2.;
		//pos += dir*f;
        color += float(MAXITER-i)/(f2+.01);
    } 
	//vec3 color3 = vec3(1.-1./(1.+color*(.1/float(MAXITER*MAXITER))));
	vec3 color3 = vec3(1. - 1. / (0.125 * cos(time) + 0.25 + color * (.1 / float(MAXITER*MAXITER))));
	color3 *= color3;
	//gl_FragColor = pow(vec4(vec3(1.003) - vec3(1.0-color3.r+color3.g+color3.b),1.), vec4(0.2));
	gl_FragColor = vec4(vec3(color3.r,color3.g,color3.b),1.);
}