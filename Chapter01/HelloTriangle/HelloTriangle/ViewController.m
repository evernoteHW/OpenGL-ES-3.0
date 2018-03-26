//
//  ViewController.m
//  HelloTriangle
//
//  Created by WeiHu on 2018/3/26.
//  Copyright © 2018年 WeiHu. All rights reserved.
//

#import "ViewController.h"
#import <GLKit/GLKit.h>
#import "Shader.h"

@interface ViewController () <GLKViewDelegate>
{
    GLuint programObject;
    Shader *shader;
}
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKView *glkView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.glkView];
    // 必须要在shader之前创建
    [EAGLContext setCurrentContext:self.context];
    shader = [[Shader alloc] initVSShader:@"v_shader" fsShader:@"f_shader"];
}
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    GLfloat vVertices[] = {
        0.0f,  0.5f, 0.0f,
        -0.5f, -0.5f, 0.0f,
        0.5f, -0.5f, 0.0f
    };
    glClear ( GL_COLOR_BUFFER_BIT );
    glClearColor(0.05f, 0.05f, 0.5f, 1);
    [shader use];
    
    GLKVector4 value = {0, 0.5, 0.5, 0.5};
    [shader setUniform4f:"ourColor" value: value];
    
    glVertexAttribPointer ( 0, 3, GL_FLOAT, GL_FALSE, 0, vVertices );
    glEnableVertexAttribArray ( 0 );
    glDrawArrays ( GL_TRIANGLES, 0, 3 );
}

#pragma mark - Setter Getter

- (GLKView *)glkView{
    if (_glkView == nil) {
        _glkView = [[GLKView alloc] initWithFrame:self.view.bounds context:self.context];
        _glkView.delegate = self;
        _glkView.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    }
    return _glkView;
}
- (EAGLContext *)context{
    if (_context == nil) {
        _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    }
    return _context;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
