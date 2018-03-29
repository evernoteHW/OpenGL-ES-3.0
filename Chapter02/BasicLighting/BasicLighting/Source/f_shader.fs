#version 300 es
precision mediump float;
out vec4 fragColor;

uniform vec3 lightPos;
uniform vec3 viewPos;

in vec3 FragPos;
in vec3 Normal;

// 结构体版本
struct Material {
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
    float shininess;
};

uniform Material material;

struct Light {
    vec3 position;
    
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
};

uniform Light light;

void main()
{
    // 环境光照
    // 光照因子
    vec3 ambient = material.ambient * light.ambient;

    // 漫反射
    vec3 lightDir = normalize(lightPos - FragPos);
    float diff = max(dot(Normal, lightDir), 0.0);
    // 漫反射因子
    vec3 diffuse = (diff * material.diffuse) * light.diffuse;

    // 镜面光照
    // 高光散射半径
    float specularStrength = 0.9;
    vec3 viewDir = normalize(viewPos-FragPos);
    vec3 reflectDir = reflect(-lightDir, Normal);
    // 漫反射因子

    // 单位矩阵余弦
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);
    vec3 specular = (spec * material.specular) * light.specular;

    vec3 result = ambient + diffuse + specular;
    
    fragColor = vec4(result, 1.0);
}
