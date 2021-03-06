#version 300 es
layout(location = 0) in vec3 vPosition;
layout(location = 1) in vec3 aColor;
layout(location = 2) in vec2 aTexCoord;

uniform mat4 transform;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

out vec3 ourColor;
out vec2 TexCoord;

void main()
{
//    gl_Position = transform * vec4(vPosition, 1.0);
    gl_Position = projection * view * model * vec4(vPosition, 1.0);
    ourColor = aColor;
    TexCoord = vec2(aTexCoord.x, aTexCoord.y);
//    TexCoord = vec2(aTexCoord.x, 1.0 - aTexCoord.y);
    
//   vertexColor = vec4(0.5, 0.0, 0.0, 1.0);
}
