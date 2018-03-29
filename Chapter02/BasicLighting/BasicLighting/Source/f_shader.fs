#version 300 es
precision mediump float;
out vec4 fragColor;

uniform vec3 lightColor;
uniform vec3 objectColor;

uniform vec3 lightPos;

in vec3 FragPos;
in vec3 Normal;

void main()
{
    // 环境光照
    float ambientStrength = 0.1;
    // 光照因子
    vec3 ambient = ambientStrength * lightColor;
    
    // 漫反射
    vec3 lightDir = normalize(lightPos - FragPos);
    float diff = max(dot(Normal, lightDir), 0.0);
    // 漫反射因子
    vec3 diffuse = diff * lightColor;
    
    vec3 result = (ambient + diffuse ) * objectColor;
    
    fragColor = vec4(result, 1.0);
}
