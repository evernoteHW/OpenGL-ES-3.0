//
//  ViewController.m
//  Demo1
//
//  Created by WeiHu on 2018/3/21.
//  Copyright © 2018年 WeiHu. All rights reserved.
//

#import "ViewController.h"
#include "esUtil.h"

extern void esMain( ESContext *esContext );
@interface ViewController ()
{
    
    GLuint programObject;
    BOOL isInit;
}
@property (strong, nonatomic) EAGLContext *context;


- (void)setupGL;
- (void)tearDownGL;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.context)
    {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [self setupGL];
}
- (EAGLContext *)context{
    if (_context == nil) {
       _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    }
    return _context;
}
- (void)dealloc
{
    [self tearDownGL];
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        [self tearDownGL];
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }
    // Dispose of any resources that can be recreated.
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
}

//- (void)update
//{
//    if ( _esContext.updateFunc )
//    {
//        _esContext.updateFunc( &_esContext, self.timeSinceLastUpdate );
//    }
//}

- (GLuint)LoadShader:(GLenum)type shaderSrc: (const char *)shaderSrc
{
 
    
    GLuint shader;
    GLint compiled;
    
    // Create the shader object
    shader = glCreateShader ( type );
    
    if ( shader == 0 )
    {
        return 0;
    }
    
    // Load the shader source
    glShaderSource ( shader, 1, &shaderSrc, NULL );
    
    // Compile the shader
    glCompileShader ( shader );
    
    // Check the compile status
    glGetShaderiv ( shader, GL_COMPILE_STATUS, &compiled );
    
    if ( !compiled )
    {
        GLint infoLen = 0;
        
        glGetShaderiv ( shader, GL_INFO_LOG_LENGTH, &infoLen );
        
        if ( infoLen > 1 )
        {
            char *infoLog = malloc ( sizeof ( char ) * infoLen );
            glGetShaderInfoLog ( shader, infoLen, NULL, infoLog );
            free ( infoLog );
        }
        
        glDeleteShader ( shader );
        return 0;
    }
    
    return shader;
}

- (BOOL)InitShader
{
    
    if (isInit) {
        isInit = TRUE;
        return FALSE;
    }
//    UserData *userData = esContext->userData;
    char vShaderStr[] =
    "#version 300 es                          \n"
    "layout(location = 0) in vec4 vPosition;  \n"
    "void main()                              \n"
    "{                                        \n"
    "   gl_Position = vPosition;              \n"
    "}                                        \n";

    char fShaderStr[] =
    "#version 300 es                              \n"
    "precision mediump float;                     \n"
    "out vec4 fragColor;                          \n"
    "void main()                                  \n"
    "{                                            \n"
    "   fragColor = vec4 ( 1.0, 0.5, 0.5, 1.0 );  \n"
    "}                                            \n";
//
    GLuint vertexShader;
    GLuint fragmentShader;
//    GLuint programObject;
    GLint linked;
//
//    // Load the vertex/fragment shaders
    
    vertexShader = [self LoadShader:GL_VERTEX_SHADER shaderSrc:vShaderStr];
    fragmentShader = [self LoadShader:GL_FRAGMENT_SHADER shaderSrc:fShaderStr];
//
//    // Create the program object
    programObject = glCreateProgram ( );
//
    if ( programObject == 0 )
    {
        return false;
    }
//
    glAttachShader ( programObject, vertexShader );
    glAttachShader ( programObject, fragmentShader );
//
//    // Link the program
    glLinkProgram ( programObject );
//
//    // Check the link status
    glGetProgramiv ( programObject, GL_LINK_STATUS, &linked );
//
    if ( !linked )
    {
        GLint infoLen = 0;

        glGetProgramiv ( programObject, GL_INFO_LOG_LENGTH, &infoLen );

        if ( infoLen > 1 )
        {
            char *infoLog = malloc ( sizeof ( char ) * infoLen );

            glGetProgramInfoLog ( programObject, infoLen, NULL, infoLog );
            esLogMessage ( "Error linking program:\n%s\n", infoLog );

            free ( infoLog );
        }

        glDeleteProgram ( programObject );
        return FALSE;
    }
//
//    // Store the program object
//    userData->programObject = programObject;
//
//
  
    return TRUE;
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
//    _esContext.width = (GLint)view.drawableWidth;
//    _esContext.height = (GLint)view.drawableHeight;
//
//    if ( _esContext.drawFunc )
//    {
//        _esContext.drawFunc( &_esContext );
//    }
    
//    [self InitShader];
//    GLfloat vVertices[] = {  0.0f,  0.5f, 0.0f,
//        -0.5f, -0.5f, 0.0f,
//        0.5f, -0.5f, 0.0f
//    };
    
    // Set the viewport
//    glViewport ( 0, 0, esContext->width, esContext->height );
    
    // Clear the color buffer
    glClear ( GL_COLOR_BUFFER_BIT );
    glClearColor(1.0f, 0.05f, 0.5f, 1);
    // Use the program object
//    glUseProgram (programObject );
//
//    // Load the vertex data
//    glVertexAttribPointer ( 0, 3, GL_FLOAT, GL_FALSE, 0, vVertices );
//    glEnableVertexAttribArray ( 0 );
//
//    glDrawArrays ( GL_TRIANGLES, 0, 3 );
//
    
}


@end

