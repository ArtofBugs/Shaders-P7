#version 330 compatibility

// lighting uniform variables -- these can be set once and left alone:
uniform float   uKa, uKd, uKs;	 // coefficients of each type of lighting -- make sum to 1.0
// uniform vec3    uColor;		 // object color
uniform vec3    uSpecularColor;	 // light color
uniform float   uShininess;	 // specular exponent

// in variables from the vertex shader and interpolated in the rasterizer:

in  vec3  gN;		   // normal vector
in  vec3  gL;		   // vector from point to light
in  vec3  gE;		   // vector from point to eye


void
main( )
{
	vec3 myColor = vec3(1., 1., 0.);

	// apply the per-fragment lighting to myColor:

	vec3 Normal = normalize(gN);
	vec3 Light  = normalize(gL);
	vec3 Eye    = normalize(gE);

	vec3 ambient = uKa * myColor;

	float dd = max( dot(Normal,Light), 0. );       // only do diffuse if the light can see the point
	vec3 diffuse = uKd * dd * myColor;

	float ss = 0.;
	if( dot(Normal,Light) > 0. )	      // only do specular if the light can see the point
	{
		vec3 ref = normalize(  reflect( -Light, Normal )  );
		ss = pow( max( dot(Eye,ref),0. ), uShininess );
	}
	vec3 specular = uKs * ss * uSpecularColor;
	gl_FragColor = vec4( ambient + diffuse + specular,  1. );
}

