#version 300 es
precision mediump float;
out vec4 fragColor;
//in vec4 vertexColor;
uniform vec4 ourColor;

void main()
{
//    fragColor = vertexColor;
    fragColor = ourColor;
//    fragColor = vec4(0.5, 0.5, 1.0, 1.0);
}
