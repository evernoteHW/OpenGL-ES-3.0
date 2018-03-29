#version 300 es
precision mediump float;
out vec4 fragColor;

uniform vec3 lightPos;
uniform vec3 viewPos;

in vec3 FragPos;
in vec3 Normal;
in vec3 Color;

// 结构体版本
struct Material {
    vec3 ambient;
    sampler2D diffuse;
    sampler2D specular;
    float shininess;
};

uniform Material material;

struct Light {
    vec3 position;
    // 定向光源
    vec3 direction;
    
    float cutOff;
    
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
    
    float constant;
    float linear;
    float quadratic;
    
    
};

uniform Light light;

in vec2 TexCoords;

void main()
{
    vec3 lightDir = normalize(light.position - FragPos);
    float theta = dot(lightDir, normalize(-light.direction));
    
    if (theta < light.cutOff) {
         fragColor = vec4(light.ambient * vec3(texture(material.diffuse, TexCoords)), 1.0);
    } else {
        // 环境光照
        // 光照因子
        vec3 ambient = vec3(texture(material.diffuse, TexCoords)) * light.ambient;
        
        // 漫反射
        
        //    vec3 lightDir = normalize(-light.direction);
        float diff = max(dot(Normal, lightDir), 0.0);
        // 漫反射因子)
        vec3 diffuse = diff * vec3(texture(material.diffuse, TexCoords)) * light.diffuse;
        
        // 镜面光照
        // 高光散射半径
        float specularStrength = 0.9;
        vec3 viewDir = normalize(viewPos-FragPos);
        vec3 reflectDir = reflect(-lightDir, Normal);
        // 漫反射因子
        
        // 单位矩阵余弦
        float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);
        
        vec3 specular = spec * (vec3(texture(material.specular, TexCoords)) ) * light.specular;
        
        // 光照衰弱因子
        
        // 固定公式
//        float distance    = length(light.position - FragPos);
//        float attenuation = 1.0 / (light.constant + light.linear * distance +
//                                   light.quadratic * (distance * distance));
//        
//        ambient  *= attenuation;
//        diffuse  *= attenuation;
//        specular *= attenuation;
        
        vec3 result = ambient + diffuse + specular;
        
        fragColor = vec4(result, 1.0);
    }
  
}
