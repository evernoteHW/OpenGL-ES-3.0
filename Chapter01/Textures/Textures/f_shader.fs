#version 300 es
precision mediump float;
out vec4 fragColor;
in vec3 ourColor;

in vec2 TexCoord;
uniform sampler2D texture1;
uniform sampler2D texture2;


void main()
{
//    fragColor = vec4(ourColor, 1.0);
//    fragColor = vec4(0,5, 0.5, 0.5 ,1.0);
//    fragColor = texture(ourTexture, TexCoord);
//    fragColor = texture(texture1, TexCoord) * vec4(ourColor, 1.0);
    fragColor = mix(texture(texture1, TexCoord), texture(texture2, TexCoord), 0.2);
//        fragColor = texture(texture2, TexCoord);
}
