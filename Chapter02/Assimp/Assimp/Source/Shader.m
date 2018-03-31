//
//  Shader.m
//  HelloTriangle
//
//  Created by WeiHu on 2018/3/26.
//  Copyright © 2018年 WeiHu. All rights reserved.
//

#import "Shader.h"
#import <OpenGLES/ES3/gl.h>

@interface Shader ()
{
    GLuint programObject;
}
@end

@implementation Shader
- (GLuint)getProgramObject;
{
    return programObject;;
}
- (instancetype)initVSShader:(NSString *)vsShader fsShader:(NSString *)fsShader
{
    self = [super init];
    if (self) {
        [self configureShader:vsShader fsShader:fsShader];
    }
    return self;
}
- (void)use{
    glUseProgram (programObject);
}
- (void)setInt:(const GLchar *)name value:(GLint)value
{
    glUniform1i(glGetUniformLocation(programObject, name), value);
}
- (void)setUniformFloat:(const GLchar *)name value:(GLfloat)value
{
    glUniform1f(glGetUniformLocation(programObject, name), value);
}
- (void)glUniform1i:(const GLchar *)name value:(GLfloat)value
{
    glUniform1i(glGetUniformLocation(programObject, name), value);
}

- (void)setUniform3f:(const GLchar *)name value:(GLKVector3)value
{
    glUniform3f(glGetUniformLocation(programObject, name), value.r, value.g, value.b);
}
- (void)setUniform4f:(const GLchar *)name value:(GLKVector4)value{
    int location = glGetUniformLocation(programObject, name);
    glUniform4f(location, value.r, value.g, value.b, value.a);
}
- (void)setUniformMatrix4fv:(const GLchar *)name value:(GLKMatrix4)value
{
    int location = glGetUniformLocation(programObject, name);
//    const GLfloat *values = [1.0, 1.0, 1.0, 1.0];
    glUniformMatrix4fv(location, 1, GL_FALSE, &value.m00);
}
- (GLuint)LoadShader:(GLenum)type shaderSrc: (const char *)shaderSrc
{
    GLuint shader = glCreateShader ( type );
    if ( shader == 0 )
    {
        return 0;
    }
    GLint compiled;
    glShaderSource ( shader, 1, &shaderSrc, NULL );
    glCompileShader (shader);
    glGetShaderiv ( shader, GL_COMPILE_STATUS, &compiled );
    
    if ( !compiled )
    {
        GLint infoLen = 0;
        glGetShaderiv ( shader, GL_INFO_LOG_LENGTH, &infoLen );
        if ( infoLen > 1 )
        {
            char *infoLog = malloc ( sizeof ( char ) * infoLen );
            glGetShaderInfoLog ( shader, infoLen, NULL, infoLog );
            NSLog( @"Error linking program:\n%s\n", infoLog);
            free ( infoLog );
        }
        glDeleteShader ( shader );
        return 0;
    }
    return shader;
}

- (void)configureShader:(NSString *)vsShader fsShader:(NSString *)fsShader
{
    NSError *error;
    NSString *vShader = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:vsShader ofType:@"vs"] encoding:NSUTF8StringEncoding error:&error];
    NSString *fShader = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fsShader ofType:@"fs"] encoding:NSUTF8StringEncoding error:&error];
    
    GLint linked;
    GLuint vertexShader = [self LoadShader:GL_VERTEX_SHADER shaderSrc:[vShader cStringUsingEncoding:NSUTF8StringEncoding]];
    GLuint fragmentShader = [self LoadShader:GL_FRAGMENT_SHADER shaderSrc:[fShader cStringUsingEncoding:NSUTF8StringEncoding]];
    programObject = glCreateProgram();
    if ( programObject == 0 )
    {
        return;
    }
    glAttachShader ( programObject, vertexShader );
    glAttachShader ( programObject, fragmentShader );
    glLinkProgram ( programObject );
    glGetProgramiv ( programObject, GL_LINK_STATUS, &linked );

    if ( !linked )
    {
        GLint infoLen = 0;
        glGetProgramiv ( programObject, GL_INFO_LOG_LENGTH, &infoLen );
        if ( infoLen > 1 )
        {
            char *infoLog = malloc ( sizeof ( char ) * infoLen );
            
            glGetProgramInfoLog ( programObject, infoLen, NULL, infoLog );
            NSLog (@"Error linking program:\n%s\n", infoLog);
            free ( infoLog );
        }
        glDeleteProgram ( programObject );
    }
}

@end
