#version 330 compatibility
#extension GL_EXT_gpu_shader4: enable
#extension GL_EXT_geometry_shader4: enable

layout( triangles )  in;
layout( line_strip, max_vertices=78 )  out;

uniform int	uLevel;
uniform float	uQuantize;
uniform float	uSize;
uniform float	uLightX, uLightY, uLightZ;

in vec3	vN[3];

out vec3	gN;		 // normal vector
out vec3	gL;		 // vector from point to light
out vec3	gE;		 // vector from point to eye

out float	gZ;      // for chroma depth

vec3 V0, V1, V2;
vec3 V01, V02;
vec3 N0, N1, N2;
vec3 N01, N02;
vec3 LIGHTPOSITION = vec3( uLightX, uLightY, uLightZ );

float
Quantize( float f )
{
        f *= uQuantize;
        int fi = int( f );
        f = float( fi ) / uQuantize;
        return f;
}

vec3
Quantize( vec3 v )
{
	return vec3(Quantize(v.x), Quantize(v.y), Quantize(v.z));
}

void
ProduceCrosses( float s, float t )
{
	vec3 v = V0 + s * (V1-V0) + t * (V2-V0);
	v = Quantize( v );

	vec3 n = N0 + s * (N1-N0) + t * (N2-N0);
	gN = normalize( gl_NormalMatrix * n ); // normal vector

	vec4 ECposition = gl_ModelViewMatrix * vec4(v,1.);
	gL = LIGHTPOSITION - ECposition.xyz;
	gE = vec3( 0., 0., 0. ) - ECposition.xyz;

	// eye coordinate depth
	gZ = -ECposition.z;

	// **Here's where uSize comes in: **

	// translate v.x to the left side of the x cross-line you want to draw:
	v.x = v.x - uSize;
	gl_Position = gl_ModelViewProjectionMatrix * vec4(v,1.);
	EmitVertex();
	// translate v.x to the right side of the x cross-line you want to draw:
	v.x = v.x + 2 * uSize;
	gl_Position = gl_ModelViewProjectionMatrix * vec4(v,1.);
	EmitVertex();
	EndPrimitive( );
	// translate v.x back to its original value:
	v.x = v.x - uSize;

	// now do the same for v.y:
	v.y = v.y - uSize;
    gl_Position = gl_ModelViewProjectionMatrix * vec4(v,1.);
	EmitVertex();
	v.y = v.y + 2 * uSize;
    gl_Position = gl_ModelViewProjectionMatrix * vec4(v,1.);
	EmitVertex();
	EndPrimitive( );
    v.y = v.y - uSize;


	// now do the same for v.z:
	v.z = v.z - uSize;
    gl_Position = gl_ModelViewProjectionMatrix * vec4(v,1.);
	EmitVertex();
	v.z = v.z + 2 * uSize;
    gl_Position = gl_ModelViewProjectionMatrix * vec4(v,1.);
	EmitVertex();
	EndPrimitive( );
    v.z = v.z - uSize;

}

void
main( )
{
	V0  =   gl_PositionIn[0].xyz;
	V1  =   gl_PositionIn[1].xyz;
	V2  =   gl_PositionIn[2].xyz;
	V01 = V1 - V0;
	V02 = V2 - V0;

	N0  =   vN[0].xyz;
	N1  =   vN[1].xyz;
	N2  =   vN[2].xyz;
	N01 = N1 - N0;
	N02 = N2 - N0;

    int numLayers = 1 << uLevel;

    float dt = 1. / float( numLayers );
    float t = 1.;

    for( int it = 0; it <= numLayers; it++ )
    {
        float smax = 1. - t;

        int nums = it + 1;
        float ds = smax / float( nums - 1 );

        float s = 0.;

        for( int is = 0; is < nums; is++ )
        {
            ProduceCrosses( s, t );
            s += ds;
        }

        t -= dt;
    }
}
