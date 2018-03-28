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
    GLKVector3 cameraPos;
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
    
    cameraPos = GLKVector3Make(0.0, 0, 5.0);
    texture = [self loadTexture:"/Users/weihu/OpenGL ES 3.0/Chapter01/Textures/Textures/container.jpg"];
    texture1 = [self loadTexture:"/Users/weihu/OpenGL ES 3.0/Chapter01/Textures/Textures/awesomeface.png"];
    
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
    
    // 欧拉角
   
    GLKMatrix4 view2 = GLKUnitMatrix4;
    // 本身屏幕宽度
//    NSLog(@"%f ", _glkView.move_x);
    
//    GLfloat camX = 0 * 5.0;
//    GLfloat camZ = 1 * 5.0;
//
//    GLfloat camX = sin(CFAbsoluteTimeGetCurrent()) * 6.0;
//    GLfloat camZ = cos(CFAbsoluteTimeGetCurrent()) * 6.0;
    
    
    GLKVector3 cameraFront = GLKVector3Make(0.0f, 0.0f, 0.0f);
    GLKVector3 cameraUp = GLKVector3Make(0.0f, 1.0f, 0.0f);
    
//    GLKVector3 newVec3 = GLKVector3Add(cameraPos, cameraFront);
    
    view2 = GLKMatrix4MakeLookAt(cameraPos.x, cameraPos.y, cameraPos.z,
                                 cameraPos.x, cameraFront.y, cameraFront.z,
                                 cameraUp.x, cameraUp.y, cameraUp.z);
    
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
//    [_glkView setNeedsDisplay];
//    CFAbsoluteTimeGetCurrent()
    
    cameraPos.x += 1;
    
//    cameraPos.z = 5.0 * cos(asin(1.0/5.0));
    [_glkView setNeedsDisplay];
}

- (IBAction)rightBtnAction:(UIButton *)sender {
    cameraPos.x -= 1;
//    cameraPos.z = 5.0 * cos(asin(1.0/5.0));
    [_glkView setNeedsDisplay];
}
- (IBAction)upBtnAction:(UIButton *)sender {
    cameraPos.z += 1;
    [_glkView setNeedsDisplay];
}
- (IBAction)downBtnAction:(UIButton *)sender {
    cameraPos.z -= 1;
    [_glkView setNeedsDisplay];
}
- (void)swipeGestrueAction:(UIPinchGestureRecognizer *)longGes
{
//    NSLog(@"缩放");
    NSLog(@"%f",longGes.velocity);
//    time = CFAbsoluteTimeGetCurrent();
//    [_glkView setNeedsDisplay];
}
- (GLuint)loadTexture:(const char *)path
{
    GLuint textureID;
    glGenBuffers(1, &textureID);
    // 绑定之前激活纹理
    //    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, textureID);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    //只能加载出PNG或者JPG
    //    UIImage *image = [UIImage imageNamed:@"123.jpg"];
    //    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    stbi_set_flip_vertically_on_load(true);
    
    GLint width, height, nrChannels;
    GLubyte *data = stbi_load(path, &width, &height, &nrChannels, 0);
    
    if (data) {
        GLint internalformat = 0;
        if (nrChannels == 3) {
            internalformat = GL_RGB;
        } else if (nrChannels == 4) {
            internalformat = GL_RGBA;
        }
        glTexImage2D(GL_TEXTURE_2D, 0, internalformat, width, height, 0, internalformat, GL_UNSIGNED_BYTE, data);
        glGenerateMipmap(GL_TEXTURE_2D);
    }
    
    stbi_image_free(data);
    
    return textureID;
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
        
        UIPinchGestureRecognizer *ges = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestrueAction:)];
        
        [_glkView addGestureRecognizer:ges];
        
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

