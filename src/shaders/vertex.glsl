
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

    //Falling
    float fallingProgress = remap(uProgress, 0.1, 1.0, 0.0, 1.0);
    fallingProgress = clamp(fallingProgress, 0.0, 1.0);
    fallingProgress = 1.0- pow(1.0 - fallingProgress, 3.0);
    newPosition.y -= fallingProgress * 0.2;

    //Scaling
    float sizeOpeningProgress = remap(uProgress, 0.0, 0.125, 0.0, 1.0);
    float sizeClosingProgress = remap(uProgress, 0.125, 1.0, 1.0, 0.0);
    float sizeProgress = min(sizeOpeningProgress, sizeClosingProgress );
    sizeProgress = clamp(sizeProgress, 0.0, 1.0);

    //Twinkling
    float TwinklingProgress = remap(uProgress, 0.2, 0.8, 0.0, 1.0);
    TwinklingProgress = clamp(TwinklingProgress, 0.0, 1.0);
    float sizeTwinkling = sin(uProgress * 30.0) * 0.5 + 0.5;
    sizeTwinkling = 1.0 - sizeTwinkling * TwinklingProgress;

    //Final Position
    vec4 modelPosition = modelMatrix * vec4(newPosition, 1.0);
    vec4 viewPosition = viewMatrix * modelPosition;
    gl_Position = projectionMatrix * viewPosition;

    //Final Size
    gl_PointSize = uSize * uResolution.y * aSize * sizeProgress * sizeTwinkling;
    gl_PointSize *= 1.0/ - viewPosition.z;
}