#include <stdio.h>
#define _USE_MATH_DEFINES
#include <math.h>

#ifndef F_PI
#define F_PI		((float)(M_PI))
#define F_2_PI		((float)(2.f*F_PI))
#define F_PI_2		((float)(F_PI/2.f))
#endif


#define GLM_FORCE_RADIANS
#include "glm/vec2.hpp"
#include "glm/vec3.hpp"
#include "glm/mat3x3.hpp"
#include "glm/mat4x4.hpp"
#include "glm/gtc/matrix_transform.hpp"
#include "glm/gtc/matrix_inverse.hpp"
#include "glm/gtc/type_ptr.hpp"


int
main( int argc, char *argv[ ] )
{
	glm::vec3 v0 = glm::vec3( 1.5, 3.0, -0.25 );
	glm::vec3 v1 = glm::vec3( 1.5, 3.0,  3.25 );
	glm::vec3 v2 = glm::vec3( 3.0, 0.0,  3.25 );
	glm::vec3 v3 = glm::vec3( 3.0, 0.0, -0.25 );
	glm::vec3 abc = glm::normalize(  glm::cross( v2-v1, v0-v1 )  );
	float d = glm::dot( -abc, v0 );

	fprintf( stderr, "%6.2f  %6.2f  %6.2f  %6.2f\n", abc.x, abc.y, abc.z, d );
	v0 = glm::vec3( 1.5, 3.0, -0.25 );
	v1 = glm::vec3( 1.5, 3.0,  3.25 );
	v2 = glm::vec3( 0.0, 0.0,  3.25 );
	v3 = glm::vec3( 0.0, 0.0, -0.25 );
	abc = glm::normalize(  glm::cross( v2-v1, v0-v1 )  );
	d = glm::dot( -abc, v0 );
	fprintf( stderr, "%6.2f  %6.2f  %6.2f  %6.2f\n", abc.x, abc.y, abc.z, d );
	return 0;
}
