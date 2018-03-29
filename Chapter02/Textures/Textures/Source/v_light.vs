#version 300 es
layout(location = 0) in vec3 aPos;

uniform mat4 mode;
uniform mat4 view;
uniform mat4 projection;

void main() {
    gl_Position = projection * view * mode * vec4(aPos, 1.0);
}
