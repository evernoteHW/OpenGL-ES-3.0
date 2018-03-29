//
//  ViewController.m
//  HelloTriangle
//
//  Created by WeiHu on 2018/3/26.
//  Copyright © 2018年 WeiHu. All rights reserved.
//

#import "ViewController.h"
#import <GLKit/GLKit.h>


#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"
#import <GLKit/GLKit.h>
#import "CustomGLKView.h"
#import "Shader.h"

#define GLKUnitMatrix4 GLKMatrix4Make(1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f)

@interface ViewController () <GLKViewDelegate>
{
    GLuint programObject;
    Shader *shader;
    Shader *lightShader;
  
    CGFloat move_orign;
    CGFloat move_x;
    CFAbsoluteTime time;
    GLKVector3 cameraPos;
    BOOL firstMouse ;
    GLfloat lastX;
    GLfloat lastY;
    GLfloat yaw;
    GLfloat pitch;
    GLKVector3 cameraFront;
    GLKVector3 lightPos;
    GLuint diffuseMap;
    GLuint specularMap;
}
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) CustomGLKView *glkView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    glEnable(GL_DEPTH_TEST);
    [self.view addSubview:self.glkView];
    // 必须要在shader之前创建
    [EAGLContext setCurrentContext:self.context];
    
    glEnable(GL_DEPTH_TEST);
    
    shader = [[Shader alloc] initVSShader:@"v_shader" fsShader:@"f_shader"];
    lightShader = [[Shader alloc] initVSShader:@"v_light" fsShader:@"f_light"];
    
    diffuseMap = [self loadTexture:"/Users/weihu/OpenGL ES 3.0/Chapter02/BasicLighting/BasicLighting/Source/container.png"];
    specularMap= [self loadTexture:"/Users/weihu/OpenGL ES 3.0/Chapter02/BasicLighting/BasicLighting/Source/container2_specular.png"];
    cameraPos = GLKVector3Make(0.0, 0, 5.0);
    
    lightPos = GLKVector3Make(-0.5, 0.5, 1.0);
    
    firstMouse = true;
    
    lastX =  800.0f / 2.0;
    lastY =  600.0 / 2.0;
    yaw   = -90.0f;
    pitch =  0.0f;
    
}
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    
    
    glClearColor(0.0f, 0.0f, 0.0f, 1);
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
    
    GLfloat normals[] = {
        0.0f,  0.0f, -1.0f,
       0.0f,  0.0f, -1.0f,
       0.0f,  0.0f, -1.0f,
       0.0f,  0.0f, -1.0f,
        0.0f,  0.0f, -1.0f,
        0.0f,  0.0f, -1.0f,
      
        0.0f,  0.0f,  1.0f,
       0.0f,  0.0f,  1.0f,
       0.0f,  0.0f,  1.0f,
       0.0f,  0.0f,  1.0f,
        0.0f,  0.0f,  1.0f,
        0.0f,  0.0f,  1.0f,
      
       -1.0f,  0.0f,  0.0f,
       -1.0f,  0.0f,  0.0f,
       -1.0f,  0.0f,  0.0f,
       -1.0f,  0.0f,  0.0f,
       -1.0f,  0.0f,  0.0f,
       -1.0f,  0.0f,  0.0f,
      
       1.0f,  0.0f,  0.0f,
       1.0f,  0.0f,  0.0f,
       1.0f,  0.0f,  0.0f,
       1.0f,  0.0f,  0.0f,
       1.0f,  0.0f,  0.0f,
       1.0f,  0.0f,  0.0f,
      
        0.0f, -1.0f,  0.0f,
       0.0f, -1.0f,  0.0f,
       0.0f, -1.0f,  0.0f,
       0.0f, -1.0f,  0.0f,
        0.0f, -1.0f,  0.0f,
        0.0f, -1.0f,  0.0f,
      
        0.0f,  1.0f,  0.0f,
       0.0f,  1.0f,  0.0f,
       0.0f,  1.0f,  0.0f,
       0.0f,  1.0f,  0.0f,
        0.0f,  1.0f,  0.0f,
        0.0f,  1.0f,  0.0f
    };
    
    
    float texCoords[] = {
        // positions          // normals           // texture coords
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
    
    [shader setUniform3f:"lightPos" value:lightPos];
    [shader setUniform3f:"viewPos" value:cameraPos];
    
    [shader setUniform3f:"material.ambient" value:GLKVector3Make(0.5, 0.5f, 0.31f)];
//    [shader setUniform3f:"material.diffuse" value:GLKVector3Make(1.0, 0.5f, 0.31f)];
    [shader setInt:"material.diffuse" value:0];
//    [shader setUniform3f:"material.specular" value:GLKVector3Make(0.5f, 0.5f, 0.5f)];
    [shader setInt:"material.specular" value:1];
    [shader setUniformFloat:"material.shininess" value:32.0];
    
    [shader setUniform3f:"light.ambient" value:GLKVector3Make(0.2f, 0.2f, 0.2f)];
    [shader setUniform3f:"light.diffuse" value:GLKVector3Make(0.5f, 0.5f, 0.5f)];
    [shader setUniform3f:"light.specular" value:GLKVector3Make(1.0f, 1.0f, 1.0f)];
    
    glVertexAttribPointer (0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), vVertices );
    glEnableVertexAttribArray ( 0 );
    
    glVertexAttribPointer (1, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), normals );
    glEnableVertexAttribArray ( 1 );
    
    glVertexAttribPointer (2, 2, GL_FLOAT, GL_FALSE, 2 * sizeof(float), texCoords );
    glEnableVertexAttribArray ( 2 );
    
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, diffuseMap);
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, specularMap);
    
    cameraFront = GLKVector3Make(0.0f, 0.0f, -1.0);
    GLKVector3 cameraUp = GLKVector3Make(0.0f, 1.0f, 0.0f);
    
    GLKVector3 newVec3 = GLKVector3Add(cameraPos, cameraFront);
    
    GLKMatrix4 view2 = GLKMatrix4MakeLookAt(cameraPos.x, cameraPos.y, cameraPos.z,
                                            newVec3.x, newVec3.y, newVec3.z,
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
    
    [lightShader use];
    glVertexAttribPointer (0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), vVertices );
    glEnableVertexAttribArray ( 0 );
    
    
    //    GLKMatrix4 cubeView = GLKUnitMatrix4;
    [lightShader setUniformMatrix4fv:"view" value:view2];
    
    GLKMatrix4 cubeProjection = GLKUnitMatrix4;
    cubeProjection = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(45.0f), 1, 0.1f, 100.0f);
    [lightShader setUniformMatrix4fv:"projection" value:cubeProjection];
    
    
    GLKMatrix4 cubeModel = GLKUnitMatrix4;
    
    cubeModel = GLKMatrix4Translate(cubeModel, lightPos.x, lightPos.y, lightPos.z);
    cubeModel = GLKMatrix4Scale(cubeModel, 0.5, 0.5, 0.5);
    [lightShader setUniformMatrix4fv:"mode" value:cubeModel];
    
    glDrawArrays(GL_TRIANGLES, 0, 36);
    
    
    //    [_glkView setNeedsDisplay];
}
- (IBAction)leftBtnAction:(UIButton *)sender {
    //    UILongPressGestureRecognizer
    //    time = CFAbsoluteTimeGetCurrent();
    //    [_glkView setNeedsDisplay];
    //    CFAbsoluteTimeGetCurrent()
//
//    cameraPos.x += 1;
//    [_glkView setNeedsDisplay];
    
    //    [self mouse_callback:10 ypos:10];
    
    lightPos.x += 0.5;
    [_glkView setNeedsDisplay];
}

- (IBAction)rightBtnAction:(UIButton *)sender {
//    cameraPos.x -= 1;
//    //    cameraPos.z = 5.0 * cos(asin(1.0/5.0));
//    [_glkView setNeedsDisplay];
    
    lightPos.x -= 0.5;
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
- (void)swipeGestrueAction:(UITapGestureRecognizer *)longGes
{
    //    NSLog(@"缩放");
    CGPoint point = [longGes locationInView:_glkView];
    if (point.x > _glkView.center.x) {
        cameraPos.x -= 1;
    } else {
        cameraPos.x += 1;
        
    }
//    NSLog(@"%f",longGes.velocity);
    //    time = CFAbsoluteTimeGetCurrent();
    [_glkView setNeedsDisplay];
}
- (void)mouse_callback:(GLfloat)xpos ypos:(GLfloat) ypos
{
    //    if(firstMouse)
    //    {
    //        lastX = xpos;
    //        lastY = ypos;
    //        firstMouse = false;
    //    }
    
    float xoffset = xpos - lastX;
    float yoffset = lastY - ypos;
    lastX = xpos;
    lastY = ypos;
    
    float sensitivity = 0.05;
    xoffset *= sensitivity;
    yoffset *= sensitivity;
    
    yaw   += xoffset;
    pitch += yoffset;
    
    if (pitch > 89.0f){
        pitch = 89.0f;
    }
    if (pitch < -89.0f) {
        pitch = -89.0f;
    }
    GLKVector3 front = GLKVector3Make(0.0, 0.0, 0.0);
    
    front.x = cos(GLKMathDegreesToRadians(yaw)) * cos(GLKMathDegreesToRadians(pitch));
    front.y = sin(GLKMathDegreesToRadians(pitch));
    front.z = sin(GLKMathDegreesToRadians(yaw)) * cos(GLKMathDegreesToRadians(pitch));
    cameraFront = GLKVector3Normalize(front);
    
    [_glkView setNeedsDisplay];
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
        
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestrueAction:)];
        
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

