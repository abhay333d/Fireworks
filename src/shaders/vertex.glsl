
uniform float uSize;
uniform vec2 uResolution;
uniform float uProgress;

attribute float aSize;

float remap(float value, float originMin, float originMax, float destinationMin, float destinationMax)
{
    return destinationMin + (value - originMin) * (destinationMax - destinationMin) / (originMax - originMin);
}

void main(){

    vec3 newPosition = position;

    //Expolsion
    float explodingProgress = remap(uProgress, 0.0, 0.1, 0.0, 1.0);
    explodingProgress = clamp(explodingProgress, 0.0, 1.0);
    explodingProgress = 1.0- pow(1.0 - explodingProgress, 3.0);
    newPosition *= explodingProgress;

    //Final Position
    vec4 modelPosition = modelMatrix * vec4(newPosition, 1.0);
    vec4 viewPosition = viewMatrix * modelPosition;
    gl_Position = projectionMatrix * viewPosition;

    //Final Size
    gl_PointSize = uSize * uResolution.y * aSize;
    gl_PointSize *= 1.0/ - viewPosition.z;
}