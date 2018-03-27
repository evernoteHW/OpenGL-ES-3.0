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

@interface ViewController () <GLKViewDelegate>
{
    GLuint programObject;
    Shader *shader;
    GLuint texture;
    GLuint texture1;
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
    
}
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(1.0f, 1.0f, 1.0f, 1);
    glClear ( GL_COLOR_BUFFER_BIT);
    
    
    GLfloat vVertices[] = {
        // 位置              // 颜色
        0.5f,  0.5f, 0.0f,      // 右上角
        0.5f, -0.5f, 0.0f,      // 右下角
       -0.5f, -0.5f, 0.0f,      // 左下角
       -0.5f,  0.5f, 0.0f,      // 左上角
    };
    
    GLfloat cVertices[] = {
        // 位置              // 颜色
        1.0f, 0.0f, 0.0f,   // 右下
        0.0f, 1.0f, 0.0f,   // 左下
        0.0f, 0.0f, 1.0f    // 顶部
    };
    
    float texCoords[] = {
        // 位置
        1.0f, 1.0f,        // 右上角
        1.0f, 0.0f,        // 右下角
        0.0f, 0.0f,       // 左下角
        0.0f, 1.0f,       // 左上角
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

    const GLubyte indices[] = {
        0, 1, 2,        // 第一个三角形
        2, 3, 0
    };
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_BYTE, indices);
    
}

#pragma mark - Setter Getter

- (GLKView *)glkView{
    if (_glkView == nil) {
        _glkView = [[GLKView alloc] initWithFrame:self.view.bounds context:self.context];
        _glkView.frame = CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.width);
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

