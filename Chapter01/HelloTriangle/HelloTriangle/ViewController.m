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
    glClearColor(1.0f, 0.5f, 1.0f, 1);
    glClear ( GL_COLOR_BUFFER_BIT);
    
    
    GLfloat vVertices[] = {
        // 位置              // 颜色
        0.5f, -0.5f, 0.0f,  1.0f, 0.0f, 0.0f,   // 右下
        -0.5f, -0.5f, 0.0f,  0.0f, 1.0f, 0.0f,   // 左下
        0.0f,  0.5f, 0.0f,  1.0f, 1.0f, 1.0f    // 顶部
    };

    GLfloat cVertices[] = {
        // 位置              // 颜色
         1.0f, 0.0f, 0.0f,   // 右下
        0.0f, 1.0f, 0.0f,   // 左下
         0.0f, 0.0f, 1.0f    // 顶部
    };


//    glViewport(0, 0, self.view.frame.size.width, self.view.frame.size.height);

    [shader use];
//
//    GLKVector4 value = {0, 0.5, 0.5, 0.5};
//    [shader setUniform4f:"ourColor" value: value];
//
    glVertexAttribPointer ( 0, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), vVertices );
    glEnableVertexAttribArray ( 0 );


    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), cVertices);
    glEnableVertexAttribArray ( 1 );
    
    glDrawArrays ( GL_TRIANGLES, 0, 3 );
}

#pragma mark - Setter Getter

- (GLKView *)glkView{
    if (_glkView == nil) {
        _glkView = [[GLKView alloc] initWithFrame:self.view.bounds context:self.context];
        _glkView.frame = CGRectMake(0, 20, 200, 300);
        _glkView.delegate = self;
        _glkView.enableSetNeedsDisplay = true;
        _glkView.backgroundColor = [UIColor orangeColor];
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
