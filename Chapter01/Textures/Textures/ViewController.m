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

#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"
#import <GLKit/GLKit.h>
#import "CustomGLKView.h"

#define GLKUnitMatrix4 GLKMatrix4Make(1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f)

@interface ViewController () <GLKViewDelegate>
{
    GLuint programObject;
    Shader *shader;
    GLuint texture;
    GLuint texture1;
    CGFloat move_orign;
    CGFloat move_x;
    CFAbsoluteTime time;
}
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) CustomGLKView *glkView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.glkView];
    // 必须要在shader之前创建
    [EAGLContext setCurrentContext:self.context];
    shader = [[Shader alloc] initVSShader:@"v_shader" fsShader:@"f_shader"];
    
    
    glGenBuffers(1, &texture);
    // 绑定之前激活纹理
//    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

    //只能加载出PNG或者JPG
//    UIImage *image = [UIImage imageNamed:@"123.jpg"];
//    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    stbi_set_flip_vertically_on_load(true);
    
    GLint width, height, nrChannels;
    GLubyte *data = stbi_load("/Users/weihu/OpenGL ES 3.0/Chapter01/Textures/Textures/container.jpg", &width, &height, &nrChannels, 0);
    
    if (data) {
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, data);
        glGenerateMipmap(GL_TEXTURE_2D);
    }
    
    stbi_image_free(data);


    glGenBuffers(1, &texture1);
    // 绑定之前激活纹理
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, texture1);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

    //只能加载出PNG或者JPG

    GLint width1, height1, nrChannels1;

    GLubyte *data1 = stbi_load("/Users/weihu/OpenGL ES 3.0/Chapter01/Textures/Textures/awesomeface.png", &width1, &height1, &nrChannels1, 0);

    if (data1) {
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width1, height1, 0, GL_RGBA, GL_UNSIGNED_BYTE, data1);
        glGenerateMipmap(GL_TEXTURE_2D);
    }
//
//    [shader use];
//    [shader glUniform1i:"texture1" value:GL_TEXTURE0];
//    [shader glUniform1i:"texture2" value:GL_TEXTURE1];
//
    stbi_image_free(data1);
    
    glEnable(GL_DEPTH_TEST);
    
}
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.5f, 1.0f, 1.0f, 1);
    glClear ( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    
    GLfloat vVertices[] = {
        // 位置              // 纹理zuo biao
        -0.5f, -0.5f, -0.5f,
        0.5f, -0.5f, -0.5f,
        0.5f,  0.5f, -0.5f,
        0.5f,  0.5f, -0.5f,
        -0.5f,  0.5f, -0.5f,
        -0.5f, -0.5f, -0.5f,
        
        -0.5f, -0.5f,  0.5f,
        0.5f, -0.5f,  0.5f,
        0.5f,  0.5f,  0.5f,
        0.5f,  0.5f,  0.5f,
        -0.5f,  0.5f,  0.5f,
        -0.5f, -0.5f,  0.5f,
        
        -0.5f,  0.5f,  0.5f,
        -0.5f,  0.5f, -0.5f,
        -0.5f, -0.5f, -0.5f,
        -0.5f, -0.5f, -0.5f,
        -0.5f, -0.5f,  0.5f,
        -0.5f,  0.5f,  0.5f,
        
        0.5f,  0.5f,  0.5f,
        0.5f,  0.5f, -0.5f,
        0.5f, -0.5f, -0.5f,
        0.5f, -0.5f, -0.5f,
        0.5f, -0.5f,  0.5f,
        0.5f,  0.5f,  0.5f,
        
        -0.5f, -0.5f, -0.5f,
        0.5f, -0.5f, -0.5f,
        0.5f, -0.5f,  0.5f,
        0.5f, -0.5f,  0.5f,
        -0.5f, -0.5f,  0.5f,
        -0.5f, -0.5f, -0.5f,
        
        -0.5f,  0.5f, -0.5f,
        0.5f,  0.5f, -0.5f,
        0.5f,  0.5f,  0.5f,
        0.5f,  0.5f,  0.5f,
        -0.5f,  0.5f,  0.5f,
        -0.5f,  0.5f, -0.5f,
    };
    
    GLfloat cVertices[] = {
        // 位置              // 颜色
        1.0f, 0.0f, 0.0f,   // 右下
        0.0f, 1.0f, 0.0f,   // 左下
        0.0f, 0.0f, 1.0f    // 顶部
    };
    
    GLfloat texCoords[] = {
         0.0f, 0.0f,
        1.0f, 0.0f,
        1.0f, 1.0f,
        1.0f, 1.0f,
         0.0f, 1.0f,
         0.0f, 0.0f,
       
         0.0f, 0.0f,
        1.0f, 0.0f,
        1.0f, 1.0f,
        1.0f, 1.0f,
         0.0f, 1.0f,
         0.0f, 0.0f,
       
         1.0f, 0.0f,
         1.0f, 1.0f,
         0.0f, 1.0f,
         0.0f, 1.0f,
         0.0f, 0.0f,
         1.0f, 0.0f,
       
        1.0f, 0.0f,
        1.0f, 1.0f,
        0.0f, 1.0f,
        0.0f, 1.0f,
        0.0f, 0.0f,
        1.0f, 0.0f,
       
         0.0f, 1.0f,
        1.0f, 1.0f,
        1.0f, 0.0f,
        1.0f, 0.0f,
         0.0f, 0.0f,
         0.0f, 1.0f,
       
         0.0f, 1.0f,
        1.0f, 1.0f,
        1.0f, 0.0f,
        1.0f, 0.0f,
         0.0f, 0.0f,
         0.0f, 1.0f
    };
    

    [shader use];
   
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    [shader glUniform1i:"texture1" value:0];
//
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, texture1);
    [shader glUniform1i:"texture2" value:1];
    
    glVertexAttribPointer (0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), vVertices );
    glEnableVertexAttribArray ( 0 );
    
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), cVertices);
    glEnableVertexAttribArray ( 1 );
    
    glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, 2 * sizeof(float), texCoords);
    glEnableVertexAttribArray ( 2 );
    

//    这里要注意第三个参数, GL_UNSIGNED_INT在OpenGL ES下已经不支持了, 现在只支持: GL_UNSIGNED_BYTE, GL_UNSIGNED_SHORT这两个参数, 我想不用说也知道,INT点4个字节, BYTE占一个,SHORT占两个, 能省就省吧,
    
    //  GL_UNSIGNED_INT在OpenGL ES下已经不支持了
//    glDrawArrays ( GL_TRIANGLES, 0, 6);

//    void glDrawElements( GLenum mode, GLsizei count,GLenum type, const GLvoid *indices）；
    
//    mode指定绘制图元的类型，它应该是下列值之一，GL_POINTS, GL_LINE_STRIP, GL_LINE_LOOP, GL_LINES, GL_TRIANGLE_STRIP, GL_TRIANGLE_FAN, GL_TRIANGLES, GL_QUAD_STRIP, GL_QUADS, and GL_POLYGON.
//    count为绘制图元的数量乘上一个图元的顶点数。
//    type为索引值的类型，只能是下列值之一：GL_UNSIGNED_BYTE, GL_UNSIGNED_SHORT, or GL_UNSIGNED_INT。
//    indices：指向索引存贮位置的指针。

//    const GLubyte indices[] = {
//        0, 1, 2,        // 第一个三角形
//        2, 3, 0
//    };
//    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_BYTE, indices);
    
   
    GLKMatrix4 view2 = GLKUnitMatrix4;
    // 本身屏幕宽度
    NSLog(@"%f ", _glkView.move_x);
    
    GLfloat camX = -sin(CFAbsoluteTimeGetCurrent()) * 10.0;
    GLfloat camZ = cos(CFAbsoluteTimeGetCurrent()) * 10.0;

    
    view2 = GLKMatrix4MakeLookAt(camX, 0.0f, camZ,
                                 0.0f, 0.0f, 0.0f,
                                 0.0f, 1.0f, 0.0f);
    
    [shader setUniformMatrix4fv:"view" value:view2];
    
    GLKMatrix4 projection = GLKUnitMatrix4;
    projection = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(45.0f), 1, 0.1f, 100.0f);
    [shader setUniformMatrix4fv:"projection" value:projection];
    
    GLKVector3 cubePositions[] = {
                                    GLKVector3Make( 0.0f,  0.0f,  0.0f),
                                    GLKVector3Make( 2.0f,  5.0f, -15.0f),
                                    GLKVector3Make(-1.5f, -2.2f, -2.5f),
                                    GLKVector3Make(-3.8f, -2.0f, -12.3f),
                                    GLKVector3Make( 2.4f, -0.4f, -3.5f),
                                    GLKVector3Make(-1.7f,  3.0f, -7.5f),
                                    GLKVector3Make( 1.3f, -2.0f, -2.5f),
                                    GLKVector3Make( 1.5f,  2.0f, -2.5f),
                                    GLKVector3Make( 1.5f,  0.2f, -1.5f),
                                    GLKVector3Make(-1.3f,  1.0f, -1.5f)
                                };
    
    for (NSInteger i = 0; i < 10; i++) {
        GLKMatrix4 model = GLKMatrix4TranslateWithVector3(GLKUnitMatrix4, cubePositions[i]);
        GLfloat angle = 20.0f * i;
        model = GLKMatrix4Rotate(model, GLKMathDegreesToRadians(angle), 1.0, 0.3, 0.5);
        [shader setUniformMatrix4fv:"model" value:model];
        glDrawArrays(GL_TRIANGLES, 0, 36);
    }
    
//    [_glkView setNeedsDisplay];
}
- (IBAction)leftBtnAction:(UIButton *)sender {
//    UILongPressGestureRecognizer
//    time = CFAbsoluteTimeGetCurrent();
    [_glkView setNeedsDisplay];
//    CFAbsoluteTimeGetCurrent()
}

- (IBAction)rightBtnAction:(UIButton *)sender {
}
- (IBAction)upBtnAction:(UIButton *)sender {
}
- (IBAction)downBtnAction:(UIButton *)sender {
}
- (void)longGestrueAction:(UILongPressGestureRecognizer *)longGes
{
    [_glkView setNeedsDisplay];
}
#pragma mark - Setter Getter

- (CustomGLKView *)glkView{
    if (_glkView == nil) {
        _glkView = [[CustomGLKView alloc] initWithFrame:self.view.bounds context:self.context];
        _glkView.frame = CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.width);
        _glkView.delegate = self;
        _glkView.enableSetNeedsDisplay = true;
        _glkView.backgroundColor = [UIColor orangeColor];
        _glkView.drawableDepthFormat = GLKViewDrawableDepthFormat24;
        
        [_glkView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGestrueAction:)]];
        
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

