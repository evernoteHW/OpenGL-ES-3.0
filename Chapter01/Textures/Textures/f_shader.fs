#version 300 es
precision mediump float;
out vec4 fragColor;
in vec3 ourColor;

in vec2 TexCoord;
uniform sampler2D ourTexture;


void main()
{
//    fragColor = vec4(ourColor, 1.0);
//    fragColor = vec4(0,5, 0.5, 0.5 ,1.0);
    fragColor = texture(ourTexture, TexCoord);
}
